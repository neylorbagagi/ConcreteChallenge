//
//  Movie.swift
//  SwiftUI002
//
//  Created by Neylor Bagagi on 30/10/21.
//

import Foundation

enum MovieFilterableProperty: String {
    case genreIDS
    case releaseDate
}

class Movie: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Movie {

    var subscription: [MovieFilterableProperty: [String]] {
        return [.genreIDS: self.genreIDS.map({ String($0) }),
                .releaseDate: [self.releaseDate]]
    }

}
