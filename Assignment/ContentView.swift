//
//  ContentView.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel(api: API())
    private let numberOfColumns = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    
    private func getItemHeight(index: Int?) -> CGFloat {
        guard let index = index else {
            return .leastNonzeroMagnitude
        }
        if index >= numberOfColumns {
            return 200.0 + 80.0 * CGFloat(numberOfColumns - 1)
        } else {
            return 200.0 + 80.0 * CGFloat(index)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            PinterestVStack(columns: numberOfColumns, spacing: 12) {
                ForEach(viewModel.items) { section in
                    ForEach(section.items) { item in
                        switch item {
                        case .image(let model):
                            ImageItemView(image: model, height: getItemHeight(index: section.items.firstIndex(of: item)))
                                .onAppear {
                                    if item == section.items.last {
                                        Task {
                                            await viewModel.loadMore()
                                        }
                                    }
                                }
                        case .video(let video):
                            VideoItemView(video: video)
                                .layoutValue(key: PinterestFullWidthKey.self, value: true)
                                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 400 : 200)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.loadPrevious()
        }
    }
}

#Preview {
    ContentView()
}

