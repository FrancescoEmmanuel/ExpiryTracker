//
//  EditCategory.swift
//  iFresh
//
//  Created by Gladys Lionardi on 01/04/25.
//

import SwiftUI
import PhotosUI

struct EditCategory: View {
    @Environment(\.dismiss) private var dismiss
    @State private var categoryName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isClicked = false // Track button state
    @ObservedObject var vm: CoreDataVM // to access core data view model
    // declare category property
    @ObservedObject var category: CategoryEntity
    
    let fileManager = LocalFileManager.instance
    let screenWidth = UIScreen.main.bounds.width
    
    // initialize biar skali jalanin lgsg load data yg ada
    init(category: CategoryEntity, vm: CoreDataVM){
        self.category = category
        self._categoryName = State(initialValue:  category.name ?? "Uncategorised")
        self.vm = vm
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.clear
                    .background(.ultraThinMaterial) // Apple's blur effect
                    .ignoresSafeArea()
                VStack {
                    ImagePicker(selectedImage: $selectedImage, displayText: "Add Photo")
                    HStack {
                        Text("Name")
                            .frame(height: 45)
                            .padding(.horizontal, 20)
                        TextField("Insert category name", text: $categoryName)
                            .frame(height: 45)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 30)
                    }
                    .frame(width: screenWidth * 0.9)
                    .background(Color.white)
                    // encompass both rectangles (text and textfield)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                    .cornerRadius(10)
                    .padding(.vertical, 40)
                    Spacer()
                    Button(action: {
                        guard !categoryName.isEmpty else { return }
                        isClicked = true // Disables button immediately
                        if let image = selectedImage {
                            let imageName = UUID().uuidString
                            fileManager.saveImg(image: image, name: imageName)
                            vm.updateCategoryImage(category: category, imageName: imageName)
                        }
                        categoryName = "" // kosongin lagi for next input
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Small delay to ensure dismissal
                                dismiss()
                        }
                        
                    }) {
                        Text("Done")
                            .foregroundStyle(Color(hex: "#0F8822"))
                            
                    }
                    .disabled(isClicked)
                    .frame(width: screenWidth*0.9, height: 60)
                    .background(isClicked ? Color(hex: "#F0F0F0") : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                    .padding(.vertical, 30)
                    
                }
                
                .frame(maxHeight: .infinity, alignment: .top)
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
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
                    Text("Edit Category")
                        .font(.system(size: 17))
                }
            }
            
        }
        .onAppear {
            if selectedImage == nil, let imageName = category.imgName {
                selectedImage = fileManager.getImage(name: imageName)
            }
        }

    }
}

//#Preview {
//    let context = CoreDataManager.instance.context
//    let category = CategoryEntity(context: context)
//    category.name = "Sample Category"
//    let vm = CoreDataVM()
//    return EditCategory(category: category, vm: vm)
//}
