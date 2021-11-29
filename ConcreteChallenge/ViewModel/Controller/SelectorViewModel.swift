//
//  SelectorViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import Foundation
import UIKit

class SelectorViewModel<T: Hashable>: NSObject, UITableViewDataSource {

    var data: [T]
    var selectedData: [T]
    var selectedDataIndex: [IndexPath]
    let filterTerm: FilterTerms

    init(data: [T], selectedData: [T], filterTerm: FilterTerms) {
        self.data = data
        self.selectedData = selectedData
        self.filterTerm = filterTerm
        self.selectedDataIndex = []
    }

    func selectedCellValue(indexPath: IndexPath) -> T {
        return data[indexPath.row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "selectorTableCell")
        cell.selectionStyle = .none
        cell.tintColor = #colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1)

        let value = data[indexPath.row]

        if self.filterTerm == .genre {
            if let genre = value as? Genre,
               let generic = AnyHashable(genre) as? T {
                if selectedData.contains(generic) {
                    cell.accessoryType = .checkmark
                    cell.isSelected = true
                }
                cell.textLabel?.text = genre.name
            }
        } else {
            if let generic = AnyHashable(value) as? T {
                if selectedData.contains(generic) {
                    cell.accessoryType = .checkmark
                    cell.isSelected = true
                }
                cell.textLabel?.text =  value as? String
            }
        }
        return cell
    }
}
