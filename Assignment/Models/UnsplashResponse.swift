//
//  UnsplashResponse.swift
//  Assignment
//
//  Created by thanh tien on 25/4/25.
//

import Foundation

struct UnsplashResponse: Codable {
    let urls: UnsplashUrls
}

struct UnsplashUrls: Codable {
    let regular: String
    let small: String
    let full: String
}
