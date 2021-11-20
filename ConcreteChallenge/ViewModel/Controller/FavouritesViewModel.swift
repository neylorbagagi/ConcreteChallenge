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
    var data:Bindable<[Movie]> = Bindable<[Movie]>([])
    var isFiltering:Bool = false
    var isSearching:Bool = false
    let file:String = "jsonData.json"
    
      
    func requestData(){
        if !self.isFiltering && !self.isSearching {
            self.cacheData = try! StorageManager.share.listMovies()
            self.data.value = self.cacheData
        }
    }
    
    func searchData(searchText:String){
        self.isSearching = true
        let filterResult:[Movie] = self.cacheData
        self.data.value = filterResult.filter({$0.title.contains(searchText)})
        
        if searchText == "" {
            self.data.value = filterResult
        }
    }
    
    func stopSearchData(){
        self.isSearching = false
        self.requestData()
    }
    
    func stopFilterData(){
        self.isFiltering = false
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
        self.data.value!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouritesTableCell", for: indexPath) as! FavouriteTableCell
        
        if let movie = self.data.value?[indexPath.row] {
            let viewModel = FavouriteCellViewModel(data:movie)
            cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let movie = self.data.value?[indexPath.row] else { return }
            
            do {
                try StorageManager.share.delete(movie: movie)
                self.data.value?.remove(at: indexPath.row)
                tableView.reloadData()
            } catch let error {
                print("\(error)")
            }
            
        }
        
    }
    
    
    
}
