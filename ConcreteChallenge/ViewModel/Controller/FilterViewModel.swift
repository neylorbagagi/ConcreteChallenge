//
//  FilterViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//
//

import Foundation
import UIKit

enum FilterTerms: String, CaseIterable {
    case releaseDate = "Date"
    case genre = "Genres"
}

class FilterViewModel: NSObject {

    var cacheData: [Movie] = []
    var filteredData: [Movie] = []
    var criteria: Bindable<Criteria> = Bindable<Criteria>(Criteria())
    var genres: Bindable<[Genre]> = Bindable<[Genre]>([])

    init(data: [Movie], criteria: Criteria? = nil) {
        super.init()

        self.cacheData = data
        self.filteredData = []

        APIClient.share.getGenres { (result) in
            switch result {
            case .success(let data):
                self.genres.value = data
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }

        if let criteria = criteria {
            self.criteria = Bindable<Criteria>(criteria)
            self.filterData()
        }

    }

    func dataForCriteria<T: Hashable>(filterTerm: FilterTerms) -> [T] {

        var result: [T] = []
        switch filterTerm {
        case .releaseDate:
            var array: [T] = []
            for movie in self.cacheData {
                if let date = movie.releaseDate.split(separator: "-").first {
                    guard let date = String(date) as? T else { return [] }
                    array.append(date)
                }
            }
            let uniques = Set(array)
            result = uniques.sorted(by: {  ( ($0 as? String ?? "") < ($1 as? String ?? "|") ) })
        case .genre:
            var array: [T] = []
            for movie in self.cacheData {
                for genreID in movie.genreIDS {
                    if let genre = self.genres.value?.first(where: {$0.id == genreID}) {
                        guard let genre = genre as? T else { return [] }
                        array.append(genre)
                    }
                }
            }

            let uniques = Set(array)
            result = uniques.sorted(by: { ( ($0 as? Genre)?.name ?? "" < ($1 as? Genre)?.name ?? "|") })
        }

        return Array(result)
    }

    func updateCriteria<T: Hashable>(value: T, filterTerm: FilterTerms) {
        switch filterTerm {
        case .releaseDate:
            guard let releases = self.criteria.value?.releaseDate,
                  let string = value as? String else { return }
            self.criteria.value?.releaseDate = self.manageCriteriaValues(currenteArray: releases,
                                                                          valueToUpdate: string)

        case .genre:
            guard let genres = self.criteria.value?.genre,
                  let genre = value as? Genre else { return }
            self.criteria.value?.genre = self.manageCriteriaValues(currenteArray: genres,
                                                                   valueToUpdate: genre )
        }

        self.filterData()
    }

    func manageCriteriaValues<T: Hashable>(currenteArray array: [T], valueToUpdate value: T) -> [T] {

        var result: [T] = array

        if !array.contains(value) {
            result.append(value)
        } else {
            if let index = array.firstIndex(of: value) {
                result.remove(at: index)
            }
        }
        return result
    }

    func filterData() {

        guard let criteria = self.criteria.value else { return }

        let genresFilter = criteria.genre.map({ $0.id })
        let releasesFilter = criteria.releaseDate
        var movies: [Movie] = self.cacheData

        if !releasesFilter.isEmpty {
            movies = movies.filter({
                for release in releasesFilter {
                    if $0.releaseDate.contains(release) {
                        return true
                    }
                }
                return false
            })
        }

        if !genresFilter.isEmpty {
            movies = movies.filter({
                for genre in genresFilter {
                    if $0.genreIDS.contains(genre) {
                        return true
                    }
                }
                return false
            })
        }

        self.filteredData = movies
    }
}

extension FilterViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterTerms.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableCell") as? FilterTableCell
        let filterTerm = FilterTerms.allCases[indexPath.row]

        guard let criteria = self.criteria.value,
              let genres = self.genres.value else { return UITableViewCell() }

        let viewModel = FilterCellViewModel(filterTerm: filterTerm, criteria: criteria, genres: genres)
        cell?.configure(viewModel: viewModel)

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "This filter returns \(self.filteredData.count) movies"
    }
}
