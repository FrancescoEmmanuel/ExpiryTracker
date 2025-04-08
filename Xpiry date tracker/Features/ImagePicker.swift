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
    let displayText: String
    
    var body: some View {
        VStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius:8))
                    .overlay(RoundedRectangle(cornerRadius:8).stroke(Color.gray, lineWidth: 2))
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaleEffect(0.6)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .background(Color(hex: "#DADADA"))
                    .clipShape(RoundedRectangle(cornerRadius:8))
            }
            
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
    }
    
    private func loadImage() {
        guard let selectedPhoto else { return }
        Task {
            if let data = try? await selectedPhoto.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
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
