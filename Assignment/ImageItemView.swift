//
//  ImageItemView.swift
//  Assignment
//
//  Created by thanh tien on 23/4/25.
//

import SwiftUI

struct ImageItemView: View {
    let image: ImageModel
    let height: CGFloat
    
    var body: some View {
        CachedImageView(url: URL(string: image.url), placeholder: nil)
            .frame(height: height)
            .clipped()
            .cornerRadius(8)
            .overlay {
                Text(image.id)
            }
    }
}
