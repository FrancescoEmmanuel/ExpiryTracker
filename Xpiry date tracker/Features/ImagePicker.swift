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
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showPhotoPicker = false

    let displayText: String

    var body: some View {
        VStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 2))
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaleEffect(0.6)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .background(Color(hex: "#DADADA"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Button(displayText) {
                showOptions = true
            }
            .foregroundStyle(Color(hex: "#0F8822"))
            .offset(y: 10)
        }
        .confirmationDialog("Select Image Source", isPresented: $showOptions, titleVisibility: .visible) {
            Button("Take Photo") {
                showCamera = true
            }

            Button("Choose from Album") {
                showPhotoPicker = true
            }

            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(selectedImage: $selectedImage)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) {
            loadImage()
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
