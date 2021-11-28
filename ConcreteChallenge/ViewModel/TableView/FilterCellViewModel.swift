//
//  FilterCellViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 24/11/21.
//

import Foundation

import UIKit
class FilterCellViewModel: NSObject {

    var title: String = ""
    var detail: String = ""

    init(filterTerm: FilterTerms, criteria: Criteria, genres: [Genre]) {
        super.init()
        self.title = filterTerm.rawValue

        switch filterTerm {
        case .releaseDate:
            self.detail = self.configureFilterPreview(params: criteria.releaseDate)

        case .genre:
            var genreNames: [String] = []
            for genreID in criteria.genre {
                if let genre = genres.first(where: {$0.id == genreID.id}) {
                    genreNames.append(genre.name)
                }
            }
            self.detail = self.configureFilterPreview(params: genreNames)
        }

    }

    private func configureFilterPreview(params: [String]) -> String {
        switch params.count {
        case 0:
            return "None"
        case 1..<4:
            return params.joined(separator: ", ")
        default:
            return "Multiple"
        }
    }
}
