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
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(width: 175.5, height: 90)
                VStack{
                    HStack (alignment: .top){
                        Image("nuGreenTea") // sementara placeholder image
                            .resizable()
                            .scaleEffect(2)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 40)
                            .clipShape(Circle())
                        Spacer()
                        
                        Menu {
                            Button(action: {
                                showEditCategory = true
                            }) {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                isClicked.toggle() // Change state on click
                                vm.deleteCategory(category)
                                
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .foregroundStyle(Color(hex: "#C6C6C8"))
                                .frame(width: 17, height: 17)
                        }
                        .sheet(isPresented: $showEditCategory) {
                            EditCategory(category: category, vm: vm)
                        }
                        
                    }
                    .padding(.horizontal)
                    HStack{
                        Text(category.name ?? "Uncategorised")
                            .font(.system(size:16))
                        Spacer()
                        Text("\(category.items?.count ?? 0) items")
                            .foregroundStyle(.gray)
                            .font(.system(size:15))
                    }
                    .padding(.horizontal)
                    
                }
                .frame(width: 185, height: 84)
            }
        }
}


#Preview {
    let previewContext = CoreDataManager.instance.context
        let sampleCategory: CategoryEntity = {
            let category = CategoryEntity(context: previewContext)
            category.name = "Drinks"
            
            let item1 = ItemEntity(context: previewContext)
            item1.name = "Milk"
            item1.categorygrouping = category

            let item2 = ItemEntity(context: previewContext)
            item2.name = "Tea"
            item2.categorygrouping = category

            category.items = NSSet(array: [item1, item2])
            return category
        }()
        
        return CategoryCard(category: sampleCategory, vm: CoreDataVM())}
