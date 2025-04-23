//
//  ItemType.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import Foundation

enum ItemType: Hashable, Identifiable {
    var id: ItemType {
        return self
    }
    
    case video(VideoModel)
    case image(ImageModel)
    case ads
}
