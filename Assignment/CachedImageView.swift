//
//  CachedImageView.swift
//  Assignment
//
//  Created by thanh tien on 23/4/25.
//

import SwiftUI

struct CachedImageView: View {
    @State private var imageLoader: ImageLoader
    
    init(url: URL?, placeholder: UIImage?) {
        self.imageLoader = ImageLoader(url: url, placeHolder: placeholder)
    }
    
    var body: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .shimmer()
        }
    }
}
