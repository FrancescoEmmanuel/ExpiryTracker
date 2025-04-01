//
//  ImagePicker.swift
//  iFresh
//
//  Created by Gladys Lionardi on 29/03/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @State private var selectedImage: UIImage? = nil
    @State private var selectedPhoto: PhotosPickerItem? = nil
    let displayText: String
    
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
    }
    
    // Function to load the selected image
    private func loadImage() {
            guard let selectedPhoto else { return } // Ensure an item was selected
            Task {
                if let data = try? await selectedPhoto.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
}

#Preview {
    ImagePicker(displayText: "Add Photo")
}
