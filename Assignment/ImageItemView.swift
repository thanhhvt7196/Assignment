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
        GeometryReader { proxy in
            CachedImageView(url: URL(string: image.url), placeholder: nil)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .cornerRadius(8)
                .overlay {
                    ZStack(alignment: .topLeading) {
                        ForEach(image.tags) { tag in
                            
                        }
                    }
                }
        }
        
        .frame(height: height)
    }
}

struct AdItemView: View {
    let index: Int
    let url: String
    let height: CGFloat
    
    var body: some View {
        CachedImageView(url: URL(string: url), placeholder: nil)
            .frame(height: height)
            .clipped()
            .cornerRadius(8)
            .overlay(alignment: .topLeading) {
                Text("AD = \(index)")
                    .foregroundStyle(.black)
                    .padding()
                    .background(.white)
                    .shadow(radius: 4)
                    .cornerRadius(8, corners: [.topLeft, .bottomRight])
            }
    }
}
