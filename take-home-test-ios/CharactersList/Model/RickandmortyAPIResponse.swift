//
//  RickandmortyAPIResponse.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 04/01/2025.
//

import Foundation

// MARK: - RickandmortyAPIResponse
struct RickandmortyAPIResponse: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String?
    
    var nextPage: Int? {
        guard let match = next?.range(of: #"(?<=\=)\d+$"#, options: .regularExpression) else {
            return nil
        }
        return Int(next?[match] ?? "")
    }
}

// MARK: - Character
struct Character: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
