//
//  Criteria.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import Foundation

struct Criteria {
    var releaseDate: [String]
    var genre: [Genre]

    init() {
        self.releaseDate = []
        self.genre = []
    }

    init(_ releaseData: [String] = [], _ genre: [Genre] = []) {
        self.releaseDate = releaseData
        self.genre = genre
    }
}
