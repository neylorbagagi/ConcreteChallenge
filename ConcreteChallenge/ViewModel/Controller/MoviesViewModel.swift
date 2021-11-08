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
        
    func requestData(){
        self.data.value = StorageManager.share.load("jsonData.json")
    }
    
    func searchData(searchText:String){
        let filterResult:[Movie] = StorageManager.share.load("jsonData.json")
        self.data.value = filterResult.filter({$0.title.contains(searchText)})
        
        if searchText == "" {
            self.data.value = filterResult
        }
    }
    
    func stopSearchData(){
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
