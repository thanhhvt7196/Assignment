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
                        itemView(item: item, index: section.items.firstIndex(of: item) ?? -1)
                            .onAppear {
                                if item == section.items.last {
                                    Task {
                                        await viewModel.loadMore()
                                    }
                                }
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
    
    @ViewBuilder
    private func itemView(item: ItemType, index: Int) -> some View {
        switch item {
        case .image(let model):
            ImageItemView(image: model, height: getItemHeight(index: index))
        case .video(let video):
            VideoItemView(video: video)
                .layoutValue(key: PinterestFullWidthKey.self, value: true)
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 400 : 200)
        case .ads(let url):
            AdItemView(index: index, url: url, height: getItemHeight(index: index))
        }
    }
}

#Preview {
    ContentView()
}

