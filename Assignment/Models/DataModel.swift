//
//  DataModel.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

struct DataModel: Codable {
    let id: String
    let video: VideoModel
    let images: [ImageModel]
}

struct DataResponse: Codable {
    let statusCode: Int
    let page: Int
    let data: DataModel
}
