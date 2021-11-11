//
//  SelectorViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import Foundation
import UIKit

class SelectorViewModel<T:Hashable>:NSObject, UITableViewDataSource {
    
    var data:[T]
    var selectedData:[T]
    let filterTerm:FilterTerms
    
    init(data:[T], selectedData:[T], filterTerm:FilterTerms) {
        self.data = data
        self.selectedData = selectedData
        self.filterTerm = filterTerm
    }
    
    func selectedCellValue(indexPath:IndexPath) -> T {
        
        let value = data[indexPath.row]
        switch self.filterTerm {
        case .genre:
            let genre = value as! Genre
            return genre.id as! T
        default:
            return value
        }
    }
    
    
    // MARK
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// TODO: make a custom check
        let cell = UITableViewCell(style: .default, reuseIdentifier: "selectorTableCell")
        cell.selectionStyle = .none
        
        let value = data[indexPath.row]
        
        
        switch self.filterTerm {
        case .genre:
            
            let genre = value as! Genre
            if selectedData.contains(AnyHashable(genre.id) as! T) {
                cell.accessoryType = .checkmark
            }
            cell.textLabel?.text = genre.name
        default:
            if selectedData.contains(AnyHashable(value) as! T) {
                cell.accessoryType = .checkmark
            }
            cell.textLabel?.text =  value as? String
        }
        print(self.data)
        return cell
    }
    
    
    
}
