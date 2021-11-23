//
//  FilterViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import Foundation
import UIKit

enum FilterTerms:String, CaseIterable{
    case releaseDate = "Date"
    case genre = "Genres"
//    case adult = "Adult Content?"
}

class FilterViewModel:NSObject {
    
    var cacheData:[Movie]
    var filteredData:[Movie] = []
    var genresData:[Genre]
    var criteria:Bindable<Criteria>
    
    init(data:[Movie], criteria:Criteria? = nil) {
        self.cacheData = data
        self.filteredData = []
        self.genresData = StorageManager.share.load("genresData.json")
        
        if let criteria = criteria {
            self.criteria = Bindable<Criteria>(criteria)
        } else{
            self.criteria = Bindable<Criteria>(Criteria())
        }
        
        
    }
    
    func dataForCriteria<T:Hashable>(filterTerm:FilterTerms) -> [T]{
        
        var result:[T] = []
        switch filterTerm {
        
        
        case .releaseDate:
            var array:[T] = []
            for movie in self.cacheData{
                if let date = movie.releaseDate.split(separator: "-").first {
                    array.append(String(date) as! T)
                }
            }
            
            let uniques = Set(array)
            result = uniques.sorted(by: { ( ($0 as! String) < ($1 as! String) ) })
            
        case .genre:
            var array:[T] = []
            for movie in self.cacheData{
                for genreID in movie.genreIDS{
                    if let genre = genresData.first(where: {$0.id == genreID}){
                        array.append(genre as! T)
                    }
                }
            }
            
            let uniques = Set(array)
            result = uniques.sorted(by: { ( ($0 as! Genre).name < ($1 as! Genre).name) })
        }
        
        return Array(result)
    }
    
    func updateCriteria<T:Hashable>(value:T, filterTerm:FilterTerms){
        
        switch filterTerm {
        case .releaseDate:
            guard let releases = self.criteria.value?.releaseDate else { return }
            self.criteria.value?.releaseDate = self.manageCriteriaValues(currenteArray: releases,
                                                                          valueToUpdate: value as! String)

        case .genre:
            guard let genres = self.criteria.value?.genre else { return }
            self.criteria.value?.genre = self.manageCriteriaValues(currenteArray: genres,
                                                                   valueToUpdate: value as! Genre ) 
        }
        
        self.filterData()
        
    }
    
    func manageCriteriaValues<T:Hashable>(currenteArray array:[T], valueToUpdate value:T) -> [T]{
        
        var result:[T] = array
        
        if !array.contains(value) {
            result.append(value)
        } else {
            if let index = array.firstIndex(of: value){
                result.remove(at: index)
            }
        }
        return result
    }
    
    func configureFilterPreview(params:[String]) -> String {
        switch params.count {
        case 0:
            return "None"
        case 1..<4:
            return params.joined(separator: ", ")
        default:
            return "Multiple"
        }
    }
    
    func filterData(){

        guard let criteria = self.criteria.value else { return }

        /// TODO: Improve this func, gettin appart anf making it generic
        let genresFilter = criteria.genre.map( {$0.id} )
        let releasesFilter = criteria.releaseDate
        var movies:[Movie] = self.cacheData

        if !releasesFilter.isEmpty {
            movies = movies.filter( {
                for release in releasesFilter {
                    if $0.releaseDate.contains(release) {
                        return true
                    }
                }
                return false
            })
        }

        if !genresFilter.isEmpty {
            movies = movies.filter( {
                for genre in genresFilter {
                    print(genre, $0.title)
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

extension FilterViewModel:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterTerms.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// TODO: move this logic to the a UITableViewCell subclass
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "filterTableCell")
        let filterTerm = FilterTerms.allCases[indexPath.row]
        cell.textLabel?.text = filterTerm.rawValue
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        switch filterTerm {
        case .releaseDate:
            if let selected = self.criteria.value?.releaseDate{
                cell.detailTextLabel?.text = self.configureFilterPreview(params: selected)
            }
            
        case .genre:
            if let selected = self.criteria.value?.genre {
                var genreNames:[String] = []
                for genreID in selected{
                    if let genre = genresData.first(where: {$0.id == genreID.id}){
                        genreNames.append(genre.name)
                    }
                }
                cell.detailTextLabel?.text = self.configureFilterPreview(params: genreNames)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "This filter return \(self.filteredData.count) movies"
    }
    
}
