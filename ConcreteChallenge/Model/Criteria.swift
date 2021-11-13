//
//  Criteria.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import Foundation

struct Criteria {
    var releaseDate:[String]
    var genre:[Genre]
    var adult:Bool
    
    init() {
        self.releaseDate = []
        self.genre = []
        self.adult = false
    }
    
    init(_ releaseData:[String] = [], _ genre:[Genre] = []) {
        self.releaseDate = releaseData
        self.genre = genre
        self.adult = false
    }
}
