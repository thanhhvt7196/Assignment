//
//  VideoItemView.swift
//  Assignment
//
//  Created by thanh tien on 23/4/25.
//

import AVKit
import SwiftUI

struct VideoItemView: View {
    @State private var showVideoPlayer = false
    @State private var videoLoader: VideoLoader
    
    init(video: VideoModel) {
        _videoLoader = State(initialValue: VideoLoader(remoteURL: URL(string: video.url)))
    }
    
    var body: some View {
        GeometryReader { proxy in
            if let thumbnail = videoLoader.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .cornerRadius(8)
                    .overlay {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                    }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .shimmer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if videoLoader.localVideoURL != nil {
                showVideoPlayer = true
            }
        }
        .fullScreenCover(isPresented: $showVideoPlayer, content: {
            VideoPlayerView(showVideoPlayer: $showVideoPlayer, url: videoLoader.localVideoURL)
        })
    }
}
