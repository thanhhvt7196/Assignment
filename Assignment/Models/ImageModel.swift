//
//  ImageModel.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

struct ImageModel: Codable, Hashable {
    let id: String
    let url: String
    let tags: [TagModel]
}
