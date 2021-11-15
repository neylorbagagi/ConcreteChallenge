//
//  FavouritesViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 07/11/21.
//

import Foundation
import UIKit

/// TODO: fix this boring LayoutConstraints warning

class FavouritesViewModel:NSObject {
    
    private var cacheData:[Movie] = []
    var data:Bindable<[Movie]> = Bindable<[Movie]>()
    var isFiltering:Bool = false
    let file:String = "jsonData.json"
    
      
    func requestData(){
        self.cacheData = StorageManager.share.load(self.file)
        self.data.value = self.cacheData
    }
    
    func searchData(searchText:String){
        
        let filterResult:[Movie] = self.cacheData
        self.data.value = filterResult.filter({$0.title.contains(searchText)})
        
        if searchText == "" {
            self.data.value = filterResult
        }
    }
    
    func stopSearchData(){
        self.requestData()
    }
    
    func stopFilterData(){
        self.isFiltering.toggle()
        self.requestData()
    }
        
    func getCacheData() -> [Movie] {
        return self.cacheData
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
