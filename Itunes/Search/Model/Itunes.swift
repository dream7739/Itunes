//
//  Itunes.swift
//  Itunes
//
//  Created by 홍정민 on 8/9/24.
//

import Foundation

struct ItunesResponse: Decodable {
    let resultCount: Int
    let results: [Itunes]
}

struct Itunes: Decodable, Hashable, Identifiable {
    var id = UUID()
    let screenshotUrls: [String]
    let artworkUrl60: String
    let artworkUrl100: String
    let artworkUrl512: String
    let currentVersionReleaseDate: String
    let releaseNotes: String
    let artistName: String
    let genres: [String]
    let price: Double
    let description: String
    let sellerName: String
    let primaryGenreName: String
    let releaseDate: String
    let trackName: String
    let minimumOsVersion: String
    let averageUserRating: Double
    let contentAdvisoryRating: String
    let version: String
    
    enum CodingKeys: CodingKey {
        case screenshotUrls
        case artworkUrl60
        case artworkUrl100
        case artworkUrl512
        case currentVersionReleaseDate
        case releaseNotes
        case artistName
        case genres
        case price
        case description
        case sellerName
        case primaryGenreName
        case releaseDate
        case trackName
        case minimumOsVersion
        case averageUserRating
        case contentAdvisoryRating
        case version
    }
}
