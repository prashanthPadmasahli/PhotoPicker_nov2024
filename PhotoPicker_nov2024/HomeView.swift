//
//  HomeView.swift
//  PhotoPicker_nov2024
//
//  Created by mac on 22/11/24.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        /// singlke selection
        VStack {
            if let image = viewModel.selectedPhoto {
                roundedImage(image: image, size: 200, radius: 20)
            }
            PhotosPicker("Select single photo", selection: $viewModel.selectedItem, matching: .images)
        }
        
        /// multiple selection
        VStack {
            if !viewModel.selectedPhotos.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.selectedPhotos, id: \.self) { image in
                            roundedImage(image: image, size: 80, radius: 5)
                        }
                    }
                }
            }
            PhotosPicker("Select multiple photos", selection: $viewModel.selectedItems, matching: .images)
        }
    }
    
    func roundedImage(image: UIImage, size: CGFloat, radius: CGFloat) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .cornerRadius(radius)
    }
}

#Preview {
    HomeView()
}



@MainActor
class HomeViewModel: ObservableObject {
    
    /// Single image selection
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            self.convertImage(item: selectedItem)
        }
    }
    @Published var selectedPhoto: UIImage?
    
    func convertImage(item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                selectedPhoto = image
            }
        }
    }
    
    
    /// Multi Image selection
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            self.convertImages(items: selectedItems)
        }
    }
    @Published var selectedPhotos: [UIImage] = []
    
    func convertImages(items: [PhotosPickerItem]) {
        Task {
            var photos: [UIImage] = []
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                    photos.append(image)
                }
            }
            selectedPhotos = photos
        }
    }
}
