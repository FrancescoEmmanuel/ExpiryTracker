//
//  ImagePicker.swift
//  iFresh
//
//  Created by Gladys Lionardi on 29/03/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {

    @Binding var selectedImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem? = nil
    let fileManager = LocalFileManager.instance
    let displayText: String
    let category: CategoryEntity
    @ObservedObject var vm: CoreDataVM
    
    var body: some View {
        VStack {
            // Display selected image
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } else {
                // Default placeholder image
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaleEffect(0.6)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            
            // PhotoPicker button
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                Text(displayText)
                    .foregroundStyle(Color(hex: "#0F8822"))
                    .offset(y: 10)
            }
            .onChange(of: selectedPhoto) {
                loadImage()
            }

        }
        .padding()
        .onAppear {
            loadSavedImage()
        }
    }
    
    private func loadSavedImage() {
            if let imgName = category.imgName, let image = fileManager.getImage(name: imgName) {
                selectedImage = image
            }
    }
    
    // Function to load the selected image
    private func loadImage() {
        guard let selectedPhoto else { return }
        Task {
            if let data = try? await selectedPhoto.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                let imgName = UUID().uuidString // Generate a unique name
                fileManager.saveImg(image: image, name: imgName)
                category.imgName = imgName // Store the new image name
                vm.saveData() // Persist changes
            }
        }
    }
}

//#Preview {
//    @Previewable @State var selectedImage: UIImage? = nil
//
//    // Create a mock CoreData context
//    let previewContext = CoreDataManager.instance.context
//
//    // Create a sample CategoryEntity
//    let sampleCategory: CategoryEntity = {
//        let category = CategoryEntity(context: previewContext)
//        category.name = "Sample Category"
//        category.imgName = "" // No saved image initially
//        return category
//    }()
//
//    ImagePicker(selectedImage: $selectedImage, displayText: "Add Photo" , category: sampleCategory, vm: CoreDataVM())
//}
