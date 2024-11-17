//
//  Movie.swift
//  Architecture_Demo_By_Arjun
//
//  Created by Arjun Thakur on 16/11/24.
//

import Foundation


import Foundation

// Create a struct to represent the movie details
struct Movie: Codable {
    var adult: Int
    var backdropPath: String
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: String
    var posterPath: String
    var releaseDate: String
    var title: String
    var video: Int
    var voteAverage: String
    var voteCount: Int

    // Coding keys to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
