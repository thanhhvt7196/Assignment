//
//  Untitled.swift
//  Assignment
//
//  Created by thanh tien on 22/4/25.
//

import Foundation

struct API {
    func getAds() async -> [UnsplashResponse] {
        return await withCheckedContinuation { continuation in
            guard let url = Bundle.main.url(forResource: "advertisement", withExtension: "json") else {
                print("💥 JSON advertisement file not found in bundle")
                continuation.resume(returning: [])
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode([UnsplashResponse].self, from: data)
                continuation.resume(returning: response)
            } catch {
                print("💥 Error loading or decoding JSON:", error)
                continuation.resume(returning: [])
            }
        }
    }
    
    func getImages(page: Int) async -> DataResponse? {
        return await withCheckedContinuation { continuation in
            let fileName: String? = {
                switch page {
                case 0:
                    return "previous"
                case 1:
                    return "current"
                case 2:
                    return "next"
                default:
                    return nil
                }
            }()
            guard let fileName = fileName, let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("💥 JSON file not found in bundle page = \(page)")
                continuation.resume(returning: nil)
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(DataResponse.self, from: data)
                continuation.resume(returning: response)
            } catch {
                print("💥 Error loading or decoding JSON:", error)
                continuation.resume(returning: nil)
            }
        }
    }
}
