//
//  ViewModel.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import Foundation
import Observation

@Observable
class ViewModel {
    let api: API
    var items: [SectionModel] = []
    private var isLoadMore = false
    private var isLoadPrevious = false
    private var page = 1
    private var canLoadMore = true
    private var canLoadPrevious = true
    
    init(api: API) {
        self.api = api
    }
    
    func loadData() async {
        page = 1
        await loadNextPage(page: page)
    }
    
    func loadMore() async {
        guard canLoadMore else {
            return
        }
        isLoadMore = true
        page = 2
        await loadNextPage(page: page)
    }
    
    func loadPrevious() async {
        guard canLoadPrevious else {
            return
        }
        isLoadPrevious = true
        await loadPrevious(page: 0)
    }
    
    private func loadNextPage(page: Int) async {
        defer {
            isLoadMore = false
        }
        guard let result = await api.getData(page: page) else {
            return
        }
        if page > 1 {
            canLoadMore = false
        }
        let video = result.data.video
        items.append(.init(type: .video, items: [.video(video)]))
        
        let images = result.data.images
        items.append(.init(type: .imageAndAd, items: images.map { .image($0) }))
    }
    
    private func loadPrevious(page: Int) async {
        defer {
            isLoadPrevious = false
        }
        guard let result = await api.getData(page: page) else {
            return
        }
        canLoadPrevious = false
        let video = result.data.video
        items.insert(.init(type: .video, items: [.video(video)]), at: 0)
        
        let images = result.data.images
        items.insert(.init(type: .imageAndAd, items: images.map { .image($0)}), at: 1)
    }
}
