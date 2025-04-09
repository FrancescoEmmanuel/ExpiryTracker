//
//  ContentView.swift
//  iFresh
//
//  Created by Gladys Lionardi on 26/03/25.
//

import SwiftUI

struct CategoryCard: View {
    let screenWidth = UIScreen.main.bounds.width
    let category: CategoryEntity
    @State private var showEditPopover = false
    @State private var isClicked = false
    @State private var showEditCategory = false
    @ObservedObject var vm: CoreDataVM
    
    @State private var selectedImage: UIImage? = nil
    let fileManager = LocalFileManager.instance
    
    var body: some View {
        VStack (spacing: 16){
                    HStack (alignment: .top){
                        if let name = category.imgName,
                           let image = fileManager.getImage(name: name) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "photo.fill") // fallback image
                                .resizable()
                                .scaleEffect(0.6)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .foregroundColor(.gray)
                                .background(Color(.systemGroupedBackground))
                                .clipShape(Circle())
                        }
                        Spacer()
                        
                        Menu {
                            Button(action: {
                                showEditCategory = true
                            }) {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                isClicked = true
                                
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .foregroundStyle(Color(hex: "#C6C6C8"))
                                
                        }
                        .sheet(isPresented: $showEditCategory) {
                            EditCategory(category: category, vm: vm)
                        }
                        
                        
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
            HStack (spacing: 8) {
                        Text(category.name ?? "Uncategorized")
                            .frame(width: 115.5, alignment: .leading)
                            .font(.system(size:16))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                                .truncationMode(.tail)
                        Text("\(category.items?.count ?? 0)")
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.gray)
                            .font(.system(size:16))
                            .frame(width: 32, alignment: .trailing)
                    }
                    .padding(.bottom, 8)
    
                }.background(Color.white)
                .frame(width: 175.5, alignment: .top)
                .cornerRadius(12)
                .alert(isPresented: $isClicked) {
                Alert(title: Text("Delete Category?"), message: Text("Are you sure you want to delete this category? It will be removed permanently."), primaryButton: .destructive(Text("Delete")){
                    vm.deleteCategory(category)
                }, secondaryButton: .cancel())
            }

        }
}

//
//#Preview {
//    let previewContext = CoreDataManager.instance.context
//        let sampleCategory: CategoryEntity = {
//            let category = CategoryEntity(context: previewContext)
//            category.name = nil
//
//            let item1 = ItemEntity(context: previewContext)
//            item1.name = "Milk"
//            item1.categorygrouping = category
//
//            let item2 = ItemEntity(context: previewContext)
//            item2.name = "Tea"
//            item2.categorygrouping = category
//
//            category.items = NSSet(array: [item1, item2])
//            return category
//        }()
//
//        return CategoryCard(category: sampleCategory, vm: CoreDataVM())}
