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

struct Itunes: Decodable, Hashable {
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
}
