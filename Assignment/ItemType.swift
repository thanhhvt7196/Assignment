//
//  ItemType.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import Foundation

struct SectionModel: Hashable, Identifiable {
    let id: UUID
    let type: ItemSectionType
    let items: [ItemType]
    
    init(id: UUID = UUID(), type: ItemSectionType, items: [ItemType]) {
        self.id = id
        self.type = type
        self.items = items
    }
}

enum ItemSectionType: Hashable, Identifiable {
    var id: ItemSectionType {
        return self
    }
    
    case imageAndAd
    case video
}

enum ItemType: Hashable, Identifiable {
    var id: ItemType {
        return self
    }
    
    case video(VideoModel)
    case image(ImageModel)
    case ads(String)
}
