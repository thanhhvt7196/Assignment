//
//  VideoCache.swift
//  Assignment
//
//  Created by thanh tien on 24/4/25.
//

import AVFoundation
import Foundation
import UIKit.UIImage

final class VideoCache {
    static let shared = VideoCache()
    
    private let fileManager = FileManager.default
    
    func localFile(for remoteURL: URL) async throws -> URL {
        let caches = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let localURL = caches.appendingPathComponent(remoteURL.lastPathComponent)
        
        if fileManager.fileExists(atPath: localURL.path) {
            return localURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: remoteURL)
        try data.write(to: localURL, options: .atomic)
        
        return localURL
    }
}

@MainActor
@Observable
final class VideoLoader {
    var thumbnail: UIImage?
    var localVideoURL: URL?
    
    init(remoteURL: URL?) {
        Task {
            guard let remoteURL = remoteURL else {
                return
            }
            do {
                let fileURL = try await VideoCache.shared.localFile(for: remoteURL)
                localVideoURL = fileURL
                
                let key = fileURL as NSURL
                if let cachedThumbnail = ImageCache.shared.object(forKey: key) {
                    thumbnail = cachedThumbnail
                } else {
                    let asset = AVURLAsset(url: fileURL)
                    let gen = AVAssetImageGenerator(asset: asset)
                    gen.appliesPreferredTrackTransform = true
                    let cmTime = CMTime(seconds: 0, preferredTimescale: 600)
                    
                    let cgImage = try await Task.detached(priority: .userInitiated) {
                        try gen.copyCGImage(at: cmTime, actualTime: nil)
                    }.value
                    
                    let uiImage = UIImage(cgImage: cgImage)
                    ImageCache.shared.setObject(uiImage, forKey: key)
                    thumbnail = uiImage
                }
            } catch {
                print("⚠️ VideoLoader failed:", error)
            }
        }
    }
}
