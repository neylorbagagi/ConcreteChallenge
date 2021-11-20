//
//  MoviesRequestResult.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 15/11/21.
//

import Foundation

struct MoviesRequestResult: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
