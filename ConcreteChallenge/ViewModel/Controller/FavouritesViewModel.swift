//
//  FavouritesViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 07/11/21.
//

import Foundation
import UIKit

class FavouritesViewModel:NSObject {
    
    var data:Bindable<[Movie]> = Bindable<[Movie]>()
    let file:String = "jsonData.json"
    
    override init() {
        
    }
    
    func requestData(){
        self.data.value = StorageManager.share.load(self.file)
    }
    
    func searchData(searchText:String){
        let filterResult:[Movie] = StorageManager.share.load(self.file)
        self.data.value = filterResult.filter({$0.title.contains(searchText)})
        
        if searchText == "" {
            self.data.value = filterResult
        }
    }
    
    func stopSearchData(){
        self.requestData()
    }
    
    func selectedData(_ indexPath:IndexPath) -> Movie? {
        guard let movie = self.data.value?[indexPath.row] else {
            print("Register not found")
            return nil
        }
        return movie
    }
    
}

extension FavouritesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouritesTableCell", for: indexPath) as! FavouriteTableCell
        
        if let movie = self.data.value?[indexPath.row] {
            let viewModel = FavouriteCellViewModel(data:movie)
            cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
}
