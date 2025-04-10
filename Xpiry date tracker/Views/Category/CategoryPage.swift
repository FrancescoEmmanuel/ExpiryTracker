//  Created by Gladys Lionardi on 26/03/25.
//

import SwiftUI


struct CategoryPage: View
{
    @Environment(\.dismiss) private var dismiss // To close the modal
    @State private var showAddCategory = false
    @State private var categoryName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var searchText = ""
    @EnvironmentObject var vm: CoreDataVM
    

    

    @Binding var selectedCategory: CategoryEntity?
    
    
    @StateObject private var viewModel = ViewModel()
    
    var filteredCategories: [CategoryEntity] {
        if searchText.isEmpty {
            return vm.categories
        } else {
            return vm.categories.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    
    //    private let catData = CategoryModel.generateCategoryModel()
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack { // Wrap in NavigationStack for in-modal navigation
            ZStack{
                Color(.systemGroupedBackground) // Semi-transparent overlay
                    .ignoresSafeArea()
                    .blur(radius: 10)
                ScrollView {
                    
                    LazyVGrid (columns: columns, spacing: 8){
                        if filteredCategories.isEmpty {
                            Text("No results found")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 250)
                        } else {
                            ForEach(filteredCategories, id:\.self) { category in
                                CategoryCard(category: category, vm: vm)
                                    .onTapGesture{
                                    
                                        viewModel.selectedCategoryName = category.name ?? "Uncategorized"
                                            selectedCategory = category
                                            dismiss()
                
                                    }
                            }
                        }
                    }
                    .padding()
                }.searchable(text: $searchText, prompt: "Search category")
                
               
            }.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                            selectedCategory = nil
                        }) {
                            HStack {
                                Image(systemName: "chevron.left") // back icon
                                    .foregroundStyle(Color(hex: "#0F8822"))
                                Text("Back")
                                    .foregroundStyle(Color(hex: "#0F8822"))
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) { // Center-aligned title
                        Text("Category")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddCategory(vm: vm).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus")
                                .foregroundStyle(Color(hex: "#0F8822"))
                        }
                        
                    }
                    
                }
            
            
            
        }
        .interactiveDismissDisabled(true)
        
        
       
        
        
        
        
    }
}
 



