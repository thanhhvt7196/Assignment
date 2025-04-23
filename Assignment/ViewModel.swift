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
    var name: String
    let api: API
    var items: [ItemType] = []
    
    init(name: String, api: API) {
        self.name = name
        self.api = api
    }
    
    func getData(page: Int) async {
        guard let result = await api.getData(page: page) else {
            return
        }
        let video = result.data.video
        items.append(.video(video))
        
        let images = result.data.images
        images.forEach {
            items.append(.image($0))
        }
        name = String(items.count)
    }
}
