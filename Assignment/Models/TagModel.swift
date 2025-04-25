//
//  TagModel.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

struct TagModel: Codable, Hashable, Identifiable {
    let id: String
    let x: String
    let y: String
    let price: Double
    let currency: String
    let unit: String
}
