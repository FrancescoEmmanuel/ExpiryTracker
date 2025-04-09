import SwiftUI

struct SearchPage: View {
    @EnvironmentObject var vm: CoreDataVM
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText = ""

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
    }
}

