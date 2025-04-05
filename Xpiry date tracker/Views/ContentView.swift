import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var vm = CoreDataVM()

    
    
    @State private var selectedCategory = "Uncategorized"
    @StateObject private var viewModel = ViewModel()
    @State private var showCategoryModal = false
    
    
//    @State var sections: [ItemSection] = [
//        ItemSection(title: "PAST DUE", color: Color.red),
//        ItemSection(title: "DUE IN 3 DAYS", color: Color.orange),
//        ItemSection(title: "DUE IN 12 DAYS", color: Color.gray),
//        ItemSection(title: "DUE LATER", color: Color.gray)
//    ]
    
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
                                CategoryButton(label: "Uncategorized", selectedCategory: $selectedCategory)
                                CategoryButton(label: "Frozen & Meat", selectedCategory: $selectedCategory)
                                CategoryButton(label: "Fruits & Vegetables", selectedCategory: $selectedCategory)
                                
                                Button {} label: {
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
                        
                        VStack(spacing:0){
                            let grouped = groupItemsByExpiry(vm.items)

                            let orderedSections = grouped.keys.sorted {
                                (sectionPriority[$0] ?? Int.max) < (sectionPriority[$1] ?? Int.max)
                            }

                            ForEach(orderedSections, id: \.self) { section in
                                if let itemsInSection = grouped[section], !itemsInSection.isEmpty {
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
                        } label: {
                            if viewModel.isEditing{
                                Text("Done").foregroundColor(Color.myGreen)
                            } else{
                                Image(systemName: "square.and.pencil").foregroundColor(.black)
                            }
                            
                        }
                    }
                    ToolbarItemGroup {
                        Button {} label: {
                            if !viewModel.isEditing{
                                Image(systemName: "magnifyingglass").foregroundColor(.black)
                            }
                        }
                        Button {} label: {
                            if !viewModel.isEditing{
                                Image(systemName: "plus").foregroundColor(.black)
                            }
                            
                        }
                        Button {
                            if viewModel.isEditing{
                                
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
                            } label:{ Text("Delete")
                                
                            }.disabled(viewModel.selectedItems.isEmpty)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 15)
                        .foregroundColor(viewModel.selectedItems.isEmpty ? Color.gray : Color.myGreen)
                        .background(.ultraThinMaterial)
                                                
                    }
                    
                }
                
                Button{
                    vm.addItem(name: "grape", quantity: 3, exp: Date())
                    
                } label:{
                    Text("Add item")
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
