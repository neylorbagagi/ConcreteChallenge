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
    var criteria:Bindable<Criteria> = Bindable<Criteria>()
    let file:String = "jsonData.json"
    
      
    func requestData(){
        self.data.value = StorageManager.share.load(self.file)
        self.cacheData = self.data.value ?? []
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
    
    func filterData(){
        
        guard let criteria = self.criteria.value else { return }
        
        /// TODO: Improve this func, semparete em make it generic
        let genresFilter = criteria.genre.map( {$0.id} )
        let releasesFilter = criteria.releaseDate
        var movies:[Movie] = StorageManager.share.load(self.file)
        
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
//                for genre in $0.genreIDS {
//                    print(genre, $0.title)
//                    if genresFilter.contains(genre) {
//                        return true
//                    }
//                }
//                return false
            })
        }
        
        self.data.value = movies
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
