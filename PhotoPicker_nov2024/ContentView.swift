//
//  ContentView.swift
//  PhotoPicker_nov2024
//
//  Created by mac on 22/11/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var selectedPhotoItem: PhotosPickerItem?
    @State var selectedPhoto: Image?
    
    var body: some View {
        VStack {
            selectedPhoto?
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(10)
            
            PhotosPicker("Select a photo", selection: $selectedPhotoItem, matching: .images)
        }
        .task(id: selectedPhotoItem) {
            selectedPhoto = try? await selectedPhotoItem?.loadTransferable(type: Image.self)
        }
    }
}

#Preview {
    ContentView()
}


extension Image: Identifiable {
    public var id: ObjectIdentifier {
        self.id
    }
}
