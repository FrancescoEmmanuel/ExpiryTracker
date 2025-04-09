import SwiftUI

struct SearchPage: View {
    @EnvironmentObject var vm: CoreDataVM
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText = ""
    @State private var showEditModal: Bool = false
    @State private var selectedItem: ItemEntity? = nil
    @State private var selectedCategory: CategoryEntity? = nil

    var filteredItems: [ItemEntity] {
        
            return vm.items.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        
    }

    var body: some View {
        NavigationStack{
            VStack{
                
                ScrollView {
                    LazyVStack() {
                        if filteredItems.isEmpty {
                            Text("No item found")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 250)
                        }else {
                            
                            ForEach(filteredItems, id: \.self) { item in
                                ItemCard(item: item, vm: vm)
                                    .padding(.horizontal)
                                    .onTapGesture {
                        
                                        selectedItem = item
                                        selectedCategory = item.categorygrouping
                                        showEditModal = true
                                        
                                    }
                                Divider()
                            }
                        }
                    }
                }.searchable(text: $searchText, prompt: "Search item").padding(.vertical)
                
            }.toolbar{
                HStack {
                    Text("Search")
                        .font(.headline)
                }.padding(.trailing, 160)
                
            }
            
        }
        .tint(Color.myGreen)
        .background(Color.background)
        .sheet(isPresented: $showEditModal) {
            EditItemView(
                selectedCategory: $selectedCategory,
                itemToEdit: $selectedItem
            )
            .environmentObject(vm)
        }
    }
}

