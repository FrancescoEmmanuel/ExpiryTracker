//  Created by Gladys Lionardi on 26/03/25.
//

import SwiftUI


struct CategoryPage: View {
    @Environment(\.dismiss) private var dismiss // To close the modal
    @State private var showAddCategory = false
    @State private var categoryName: String = ""
    @State private var selectedImage: UIImage? = nil
    @EnvironmentObject var vm: CoreDataVM

    @Binding var showAddModal : Bool
    @Binding var selectedCategory: CategoryEntity?
    
    
//    private let catData = CategoryModel.generateCategoryModel()
    let columns = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]
    
    var body: some View {
        NavigationStack { // Wrap in NavigationStack for in-modal navigation
            ZStack{
                Color.white.opacity(0.2) // Semi-transparent overlay
                    .ignoresSafeArea()
                    .blur(radius: 10)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(vm.categories, id: \.self) { category in
                            CategoryCard(category: category, vm: vm)
                                .onTapGesture{
                                    if showAddModal == true {
                                        selectedCategory = category
                                        dismiss()
                                    }
                                
                            }
//
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss() // Close the modal
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
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddCategory(vm: vm).navigationBarBackButtonHidden(true)) { 
                            Image(systemName: "plus")
                                .foregroundStyle(Color(hex: "#0F8822"))
                        }
                    
                        
                        // the following code is used when we want to open AddCategory as a modal
//                        Button {
//                        } label: {
//                            Image(systemName: "plus")
//                                .foregroundStyle(Color(hex: "#0F8822"))
//                        }
//                        .sheet(isPresented: $showAddCategory) {
//                            AddCategory(vm: vm)
//                        }
                    }
                    
                }
            }
            
            
        }
    }
}
 



