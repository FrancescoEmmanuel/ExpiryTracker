import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var vm = CoreDataVM()
    
    @State private var selectedCategory: CategoryEntity?
    @StateObject private var viewModel = ViewModel()
    
    @State private var showCategoryModal = false
    @State private var showAddCategoryModal = false
    @State private var showDeleteAlert: Bool = false
   
    
    
    let sectionPriority: [String: Int] = [
        "PAST DUE": 0,
        "DUE TOMORROW": 1,
        "DUE IN 2 DAYS": 2,
        "DUE IN 3 DAYS": 3,
        "DUE IN 4 DAYS": 4,
        "DUE IN 5 DAYS": 5,
        "DUE IN 6 DAYS": 6,
        "DUE IN 7 DAYS": 7,
        "FAR FROM DUE": 8
    ]
    
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView{
                    VStack(alignment:.leading, spacing: 0) {
                        
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack {
                                    
                                    CategoryButton(label: "All", selectedCategory: $viewModel.selectedCategoryName)
                                    
                                    ForEach(vm.categories, id: \.self){ category in
                                        CategoryButton(label: category.name ?? "", selectedCategory: $viewModel.selectedCategoryName)
                                        

                                    }
                                    
                                    Button {
                                        showAddCategoryModal.toggle()
                                    } label: {
                                        Image(systemName: "plus").foregroundColor(.gray)
                                        
                                    }.padding() .background(Color.white.opacity(0.5))
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(40)
                                        .frame(height:34)
                                        .clipShape(.circle)
                                        .padding(.bottom, 10)
                                    
                                }
                
                        }.padding(.horizontal, 12)
                            .padding(.top, 20)
                        
                        
                        
                        NavigationLink(destination: ArchivePage(vm:vm)){
                            
                            HStack{
                                Image(systemName: "bin.xmark.fill").frame(width: 23, height: 19).foregroundColor(.myGray)
                                Text("Archived").fontWeight(.medium).font(.system(size: 16)).foregroundColor(.myGray)
                                Spacer()
                                
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 10)
                            .padding(.top,13)
                            
                            
                        }
                        
                        if vm.items.isEmpty {
                            
                            Text("No items found").font(.subheadline).foregroundColor(.gray)
                                .padding(.horizontal,142)
                                .padding(.vertical,250)
                        }
                        
                        VStack(spacing:0){
                            
                            let filteredItems = vm.items.filter { item in
                                guard item.archived == false else { return false }
                                switch viewModel.selectedCategoryName {
                                case "All":
                                    return true
                                default:
                                    return item.categorygrouping?.name == viewModel.selectedCategoryName
                                }
                            }
                            
                            
                            let grouped = groupItemsByExpiry(filteredItems)
                            
                            let orderedSections = grouped.keys.sorted {
                                (sectionPriority[$0] ?? Int.max) < (sectionPriority[$1] ?? Int.max)
                            }
                            
                            ForEach(orderedSections, id: \.self) { section in
                                if let itemsInSection = grouped[section], !itemsInSection.isEmpty{
                                    ItemSection(
                                        title: section,
                                        items: itemsInSection
                                    )
                                    .environmentObject(vm)
                                    .environmentObject(viewModel)
                                }
                            }
                            .padding(.bottom,10)
                            
                        }
                        
                        
                    }
                }
                .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewModel.isEditing.toggle()
                            vm.items.forEach { viewModel.selectedItems.remove($0.id ?? UUID()) }
                            
                        } label: {
                            if viewModel.isEditing{
                                Text("Done").foregroundColor(Color.myGreen)
                            } else{
                                Image(systemName: "square.and.pencil").foregroundColor(.black)
                            }
                            
                        }
                    }
                    ToolbarItemGroup {
                        
                        if !viewModel.isEditing{
                            NavigationLink(destination: SearchPage().environmentObject(vm).environmentObject(viewModel)) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                            }
                            
                        }
                       

                        
                        Button {
                            if !viewModel.isEditing{
                                viewModel.showAddModal = true
                
                            }
                            
                        } label: {
                            if !viewModel.isEditing{
                                Image(systemName: "plus").foregroundColor(.black)
                                
                                
                            }
                            
                        }
                        
                        Button {
                            if viewModel.isEditing{
                                vm.items.forEach { viewModel.selectedItems.insert($0.id ?? UUID()) }
                                
                            }else{
                                showCategoryModal.toggle()
                                
                            }
                            
                        } label: {
                            if viewModel.isEditing{
                                Text("Select All").foregroundColor(Color.myGreen)
                                
                            } else{
                                Image(systemName: "square.grid.2x2").foregroundColor(.black)
                            }
                            
                        }
                    }
                        
                }
                if viewModel.isEditing{
                    VStack{
                        Spacer()
                        HStack{
                            Button{
                                
                                viewModel.selectedItems.forEach { item in
                                    if let itemToArchive = vm.items.first(where: { $0.id == item }) {
                                        vm.toggleArchiveItem(itemToArchive)
                                    }
                                }
                                viewModel.selectedItems.removeAll()
                                
                                viewModel.isEditing.toggle()
                                
                            } label:{ Text("Archive")
                                
                                
                                
                            }.disabled(viewModel.selectedItems.isEmpty)
                            
                            Spacer()
                            
                            Button{
                            } label:{ Text("Move")
                                
                            }.disabled(viewModel.selectedItems.isEmpty)
//                                .alert(isPresented: $showDeleteAlert) {
//                                    Alert(
//                                        title: Text("Move Items?"),
//                                        message: Text("Are you sure you want to move these items?"),
//                                        primaryButton: (Text("Move")) {
//                                            showCategoryModal = true},
//                                        secondaryButton: .cancel()
//                                    )
//                                }
//                                .sheet(isPresented: $showCategoryModal) {
//                                    CategoryPage( selectedCategory: $selectedCategory).environmentObject(vm) {
//                                        if let category = selectedCategory {
//                                            viewModel.selectedItems.forEach { item in
//                                                if let itemToMove = vm.items.first(where: { $0.id == item }) {
//                                                    vm.updateItem(entity: itemToMove, newCategory: category)
//                                                }
//                                            }
//                                            viewModel.isEditing.toggle()
//                                        }
//                                    }
//                                }
                            
                            Spacer()
                            
                            Button{
                                
                                showDeleteAlert = true
                                
                            } label:{ Text("Delete")}.disabled(viewModel.selectedItems.isEmpty).alert(isPresented: $showDeleteAlert) {
                                Alert(
                                    title: Text("Delete Items?"),
                                    message: Text("Are you sure you want to delete these items? They will be removed permanently from your list."),
                                    
                                    primaryButton: .destructive(Text("Delete")) {
                                        
                                        viewModel.selectedItems.forEach { item in
                                            if let itemToDelete = vm.items.first(where: { $0.id == item }) {
                                                vm.deleteItem(itemToDelete)
                                            }
                                        }
                                        viewModel.selectedItems.removeAll()
                                        
                                        viewModel.isEditing.toggle()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 15)
                        .foregroundColor(viewModel.selectedItems.isEmpty ? Color.gray : Color.myGreen)
                        .background(.ultraThinMaterial)
                        
                    }
                    
                }

            }.sheet(isPresented: $showCategoryModal) {
                CategoryPage( selectedCategory: $selectedCategory).environmentObject(vm)
            }
            .sheet(isPresented: $viewModel.showAddModal) {
                AddItemView(selectedCategory: $selectedCategory).environmentObject(vm)
            }
            .sheet(isPresented: $showAddCategoryModal) {
                AddCategory(vm:vm)
            }
            .onChange(of: selectedCategory) {
                viewModel.selectedCategoryName = selectedCategory?.name ?? "All"
            }

            
            
        }
    }

}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController().container.viewContext)
}
