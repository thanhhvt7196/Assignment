//
//  ImageCache.swift
//  Assignment
//
//  Created by thanh tien on 23/4/25.
//

import Combine
import Foundation
import UIKit.UIImage

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

@MainActor
@Observable
final class ImageLoader {
    let placeHolder: UIImage
    var image: UIImage?
    var isLoading = false
    private let url: URL?
    
    init(url: URL?, placeHolder: UIImage? = UIImage(systemName: "photo")) {
        self.url = url
        self.placeHolder = placeHolder ?? UIImage()
        Task {
            await load()
        }
    }
    
    private func load() async {
        isLoading = true
        defer {
            isLoading = false
        }
        guard let url = url else {
            image = nil
            return
        }
        
        let key = url as NSURL
    
        if let cached = ImageCache.shared.object(forKey: key) {
            image = cached
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: key)
                image = uiImage
            } else {
                image = placeHolder
            }
        } catch {
            print("error = \(error)")
            image = placeHolder
        }
    }
}
