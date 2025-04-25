//
//  VideoPlayerView.swift
//  Assignment
//
//  Created by thanh tien on 25/4/25.
//

import AVKit
import SwiftUI

struct VideoPlayerView: View {
    @Binding var showVideoPlayer: Bool
    @State private var player: AVPlayer?
    
    init(showVideoPlayer: Binding<Bool>, url: URL?) {
        _showVideoPlayer = showVideoPlayer
        if let url {
            _player = State(initialValue: AVPlayer(url: url))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showVideoPlayer = false
            } label: {
                Image(systemName: "multiply")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 16)
            }
            .contentShape(Rectangle())
            .frame(width: 24, height: 24)
            .padding()
            
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                    }
            } else {
                VStack {
                    Spacer()
                    
                    ProgressView("Loading video...")
                        .progressViewStyle(.circular)
                        .background(.yellow)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.black)
    }
}
