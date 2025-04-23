//
//  ContentView.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ViewModel(name: "hahaha", api: API())
    
    private func getItemHeight(index: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            switch index % 3 {
            case 0:
                return 340
            case 1:
                return 270
            default:
                return 230
            }
        } else {
            return index % 2 == 0 ? 120 : 160
        }
    }
    
    var body: some View {
        ScrollView(content: {
            PinterestVStack(columns: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2, spacing: 12) {
                ForEach(viewModel.items) { item in
                    switch item {
                    case .ads:
                        EmptyView()
                    case .image(let image):
                        let index = viewModel.items.firstIndex(of: item) ?? 0
                        ImagePlaceholderView(image: image, height: getItemHeight(index: index))
                    case .video(let video):
                        VideoPlaceholderView()
                            .layoutValue(key: PinterestFullWidthKey.self, value: true)
                    }
                }
            }
        })
        .task {
            await viewModel.getData(page: 1)
        }
    }
}

#Preview {
    ContentView()
}

struct VideoPlaceholderView: View {
  var body: some View {
    VStack {
      Image(systemName: "play.circle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 50, height: 50)
        .foregroundColor(.green)
        
      Text("Main Video Content")
        .font(.headline)
    }
    .frame(maxWidth: .infinity)
    .background(Color.green.opacity(0.2))
  }
}

struct ImagePlaceholderView: View {
    let image: ImageModel
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3))
            .frame(height: height)
            .overlay(
                Text("Item \(image.id)")
                    .foregroundColor(.black)
                    .font(.caption)
            )
            .cornerRadius(8)
    }
}
