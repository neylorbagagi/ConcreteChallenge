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
    
    /// TODO: maybe all cache should be at Cashe object!!!
//    private var cacheData:[Movie] = []
    var data:Bindable<[Movie]> = Bindable<[Movie]>([])
    var isFiltering:Bool = false
    var isSearching:Bool = false
    let file:String = "jsonData.json"
    
      
    func requestData(){
        
        Cache.share.subscribe({ movies in
            
            self.data.value = movies
            
        })
        
//        Cache.share.favourites.observer = { movies in
//            guard let movies = movies else { return }
//            self.data.value = movies
//        }
        
        if !self.isFiltering && !self.isSearching {
            
            
            self.data.value = Cache.share.favourites
            
            
//            self.cacheData = try! StorageManager.share.listMovies()
//            self.data.value = Cache.share.favourites.value ?? []  //self.cacheData
        }
    }
    
    func searchData(searchText:String){
        self.isSearching = true
        let filterResult:[Movie] = Cache.share.favourites //self.cacheData
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
        return Cache.share.favourites  //Cache.share.favourites.value
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
                try Cache.share.delete(movie: movie)
//                self.data.value?.remove(at: indexPath.row)
//                tableView.reloadData()
            } catch let error {
                print("\(error)")
            }
            
        }
        
    }
    
    
    
}
