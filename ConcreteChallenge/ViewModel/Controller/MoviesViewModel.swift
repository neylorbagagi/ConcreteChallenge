//
//  MoviesViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import Foundation
import UIKit

class MoviesViewModel:NSObject {
    
    var data:Bindable<[Movie]> = Bindable<[Movie]>()
    let file:String = "jsonData.json"
    var isSearching:Bool = false
    
    func requestData(){
        
//        var pageToRequest = 1
//        if UserDefaults.standard.object(forKey: "pageToRequest") != nil {
//            pageToRequest = UserDefaults.standard.integer(forKey: "pageToRequest")
//        }
//
//
//
//        // Inicialmente vai retornar todos os filmes e depois incrementar com novos retornos do Realm
//        StorageManager.share.getMovies(byPage: pageToRequest) { (data, error) in
//            guard error == nil else{
//                print(error?.localizedDescription)
//                self.data.value = data
//                return
//            }
//
//            pageToRequest += 1
//            UserDefaults.standard.setValue(pageToRequest, forKey: "pageToRequest")
//            self.data.value = data
//        }
        if !self.isSearching {
            self.data.value = StorageManager.share.load(self.file)
        }
        
    }
    
    func searchData(searchText:String){
        self.isSearching = true
        let filterResult:[Movie] = StorageManager.share.load(self.file)
        self.data.value = filterResult.filter({$0.title.contains(searchText)})
        
        if searchText == "" {
            self.data.value = filterResult
        }
    }
    
    func stopSearchData(){
        self.isSearching = false
        self.requestData()
    }
    
    func collectionSelectedData(_ indexPath:IndexPath) -> Movie? {
        guard let movie = self.data.value?[indexPath.row] else {
            print("Register not found")
            return nil
        }
        return movie
    }
    
    
}

extension MoviesViewModel:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.data.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        
        let viewModel = MovieCellViewModel(movie: self.data.value![indexPath.row])
        cell.configure(viewModel:viewModel)
        
        return cell
    }
}
