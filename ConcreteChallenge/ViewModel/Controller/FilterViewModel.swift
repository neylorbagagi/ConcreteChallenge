//
//  FilterViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import Foundation
import UIKit



/// struct can be CaseIterable? create a structure to save filter configuration in cache
/// // use cashe for filter options

enum FilterTerms:String, CaseIterable{
    case releaseDate = "Date"
    case genre = "Genres"
//    case adult = "Adult Content?"
}

class FilterViewModel:NSObject {
    
    var data:[Movie]
    var genres:[Genre] = []
    var criteria:Bindable<Criteria>
    
    init(data:[Movie], criteria:Criteria) {
        self.data = data
        self.criteria = Bindable<Criteria>(criteria)
    }
    
    func dataForCriteria<T:Hashable>(filterTerm:FilterTerms) -> [T]{
        
        var result:[T] = []
        switch filterTerm {
        
        
        case .releaseDate:
            var array:[T] = []
            for movie in self.data{
                if let date = movie.releaseDate.split(separator: "-").first {
                    array.append(String(date) as! T)
                }
            }
            
            let uniques = Set(array)
            result = uniques.sorted(by: { ( ($0 as! String) < ($1 as! String) ) })
            
        case .genre:
            var array:[T] = []
            self.genres = StorageManager.share.load("genresData.json")
            for movie in self.data{
                for genreID in movie.genreIDS{
                    if let genre = genres.first(where: {$0.id == genreID}){
                        array.append(genre as! T)
                    }
                }
            }
            
            let uniques = Set(array)
            result = uniques.sorted(by: { ( ($0 as! Genre).name < ($1 as! Genre).name) })
        }
        
        return Array(result)
    }
    
    func updateCriteria<T:Hashable>(value:T,filterTerm:FilterTerms){
        
        switch filterTerm {
        case .releaseDate:
            guard let releases = self.criteria.value?.releaseDate else { return }
            self.criteria.value?.releaseDate = self.manageCriteriaValues(currenteArray: releases,
                                                                          valueToUpdate: value as! String)
            
        default:
            guard let genres = self.criteria.value?.genre else { return }
            self.criteria.value?.genre = self.manageCriteriaValues(currenteArray: genres,
                                                                   valueToUpdate: value as! Int)
        }
        
    }
    
    func manageCriteriaValues<T:Hashable>(currenteArray array:[T], valueToUpdate value:T) -> [T]{
        
        var newArray:[T] = array
        
        if !array.contains(value) {
            newArray.append(value)
        } else {
            if let index = array.firstIndex(of: value){
                newArray.remove(at: index)
            }
        }
        return newArray
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
                    if let genre = genres.first(where: {$0.id == genreID}){
                        genreNames.append(genre.name)
                    }
                }
                cell.detailTextLabel?.text = self.configureFilterPreview(params: genreNames)
            }
        }
        
        return cell
    }
    
}
