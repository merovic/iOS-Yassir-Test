//
//  RickandmortyAPIRequest.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 04/01/2025.
//

// MARK: - RickandmortyAPIRequest
struct RickandmortyAPIRequest: Codable {
    let page: String
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
    }
}
