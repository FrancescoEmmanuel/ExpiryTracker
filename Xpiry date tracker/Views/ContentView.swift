import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var vm = CoreDataVM()
    
    
    
    @State private var selectedCategory = "All"
    @StateObject private var viewModel = ViewModel()
    @State private var showCategoryModal = false
    @State private var showDeleteAlert: Bool = false
    
    
    
    
    let sectionPriority: [String: Int] = [
        "Expired": 0,
        "Expiring Tomorrow": 1,
        "Expiring in 2 Days": 2,
        "Expiring in 3 Days": 3,
        "Expiring in 4 Days": 4,
        "Expiring in 5 Days": 5,
        "Expiring in 6 Days": 6,
        "Expiring in 7 Days": 7,
        "Expiring Later": 8
    ]
    
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment:.leading, spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack {
                                CategoryButton(label: "All", selectedCategory: $selectedCategory)
                                CategoryButton(label: "Uncategorized", selectedCategory: $selectedCategory)
                                
                                ForEach(vm.categories, id: \.self){ category in
                                    CategoryButton(label: category.name ?? "", selectedCategory: $selectedCategory)
                                    
                                }
                                
                                
                                Button {
                                    showCategoryModal.toggle()
                                } label: {
                                    Image(systemName: "plus").foregroundColor(.gray)
                                }.padding() .background(Color.white.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(40)
                                    .frame(height:34)
                                    .clipShape(.circle)
                                    .padding(.bottom, 10)
                                
                                
                                
                                
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 20)
                            
                            
                            
                        }
                        
                        
                        NavigationLink(destination: ContentView()){
                            
                            HStack{
                                Image(systemName: "bin.xmark.fill").frame(width: 23, height: 19).foregroundColor(.myGray)
                                Text("Archived").font(.system(size: 16)).foregroundColor(.myGray)
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
                                switch selectedCategory {
                                case "All":
                                    return true
                                default:
                                    return item.categorygrouping?.name == selectedCategory
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
                        
                        NavigationLink(destination: SearchPage().environmentObject(vm).environmentObject(viewModel)) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                        }
                        .disabled(viewModel.isEditing)
                        

                       
                        Button {} label: {
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
                            }else{
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
                            } label:{ Text("Archive")
                                
                            }.disabled(viewModel.selectedItems.isEmpty)
                            
                            Spacer()
                            
                            Button{
                            } label:{ Text("Move")
                                
                            }.disabled(viewModel.selectedItems.isEmpty)
                            
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
                
                
                VStack{
                    Spacer()
                    Button{
                        
//                        let a = vm.categories[1]
                        vm.addItem(name: "grape", quantity: 3, exp: Date())
                        
                    } label:{
                        Text("Add item")
                    }
                    
                }
                
                
                
                
                
                
            }.sheet(isPresented: $showCategoryModal) {
                CategoryPage()
            }
            
            
        }
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController().container.viewContext)
}
