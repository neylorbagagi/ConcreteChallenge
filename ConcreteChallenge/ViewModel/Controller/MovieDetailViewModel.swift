//
//  MovieDetailViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import Foundation
import UIKit
                              // [String,String]
enum MovieDetailViewModelInfoKey:String, CaseIterable {
    case voteAverage = "Vote Average"
    case voteCount = "Votes Count"
    case releaseDate = "Release Date"
    case popularity = "Popularity Rate"
    case genres = "Genres"
    case originalLanguage = "Original Language"
    case adult = "Adult Content?"
}

class MovieDetailViewModel:NSObject {
    
    private let data:Movie
    let title:String
    let originalTitle:String
    let releaseDate:String
    let overview:String
    let voteAverage:String
    let voteCount:String
    let popularity:String
    let adult:String
    let originalLanguage:String
    var backdrop:Bindable<UIImage> = Bindable<UIImage>()
    var genres:String
    var info:Bindable<[MovieDetailViewModelInfoKey:String]> = Bindable<[MovieDetailViewModelInfoKey:String]>()
    var isFavourite:Bool = false
    
    init(movie:Movie) {
        self.data = movie
        self.title = movie.title
        self.originalTitle = "(\(movie.originalTitle))"
        self.releaseDate = String(movie.releaseDate.split(separator: "-").first ?? "UNKNOW")
        self.overview = movie.overview
        self.voteAverage = String(movie.voteAverage)
        self.voteCount = MovieDetailViewModel.formatPoints(from: movie.voteCount)
        self.genres = "N/A"
        
        let popularityString = String(movie.popularity)
        self.popularity = String(popularityString.split(separator: ".").first ?? "0") // let's make it more readable
        self.adult = movie.adult == true ? "YES" : "NO"
        self.originalLanguage = movie.originalLanguage
        self.info.value = [.voteAverage:self.voteAverage,.voteCount:self.voteCount,
                     .releaseDate:self.releaseDate,.popularity:self.popularity,
                     .originalLanguage:self.originalLanguage,.adult:self.adult,
                     .genres:self.genres]
       
        self.isFavourite = StorageManager.share.checkMovieFavouriteState(movie: self.data)
        
//        MovieDetailViewModel.checkFavouriteState(movie:self.data)
        
    }
    
//    static func checkFavouriteState(movie:Movie) -> Bool {
//        var response:Bool = false
//
//        do {
//            response = try StorageManager.share.listMovies().contains(where: { $0.id == movie.id})
//        } catch let error {
//            print("\(error)")
//        }
//
//        return response
//    }
    
    func requestImage() {
        
        if let cachedImage = Cache.share.images.object(forKey: self.data.backdropPath as AnyObject){
            self.backdrop.value = cachedImage
            return
        }
        
        DispatchQueue.init(label: "imageLoading", qos: .background).async {
            
            let base_path = "https://image.tmdb.org/t/p/w500"
            
            guard let url = URL(string: base_path+(self.data.backdropPath ?? "")) else {
                print("invalid url")
                return
            }
            
            do {
                let imageData = try Data(contentsOf: url)
                guard let image = UIImage(data: imageData) else { return }
                Cache.share.images.setObject(image, forKey: self.data.backdropPath as AnyObject)
                self.backdrop.value = image
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestGenres(){
        
        DispatchQueue.init(label: "genresLoading", qos: .background).async {
        
            var composedGenres = ""
            let genres:[Genre] = StorageManager.share.load("genresData.json")
            
            for id in self.data.genreIDS{
                if let genderName = genres.first(where: {$0.id == id})?.name {
                    composedGenres += "\(genderName)"
                    
                    if id != self.data.genreIDS.last{
                        composedGenres += ",\n"
                    }
                    
                }
            }
            
            self.genres = composedGenres
            self.info.value?[.genres] = self.genres
        }
        
    }
    
    func updateMoviewFavouriteState(to state:Bool) throws {
        
        if !state {
            do {
                try StorageManager.share.save(movie: self.data)
            } catch let error {
                print("\(error)")
            }
        } else {
            do {
                try StorageManager.share.delete(movie: self.data)
            } catch let error {
                print("\(error)")
            }
        }
        
    }
    
    class private func formatPoints(from: Int) -> String {

        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        
        if billion >= 1.0 {
            return "\(round(billion*10)/10)B"
        } else if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return ("\(round(thousand*10/10))K")
        } else {
            return "\(Int(number))"
        }
    }
    
}

extension MovieDetailViewModel:UICollectionViewDataSource {
       
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MovieDetailViewModelInfoKey.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCollectionCell", for: indexPath) as! InfoCollectionViewCell
        
        let currentKey = MovieDetailViewModelInfoKey.allCases[indexPath.row]
        
        let key = currentKey.rawValue
        if let value = self.info.value?[currentKey] {
            let viewModel = InfoCellViewModel(info: [key:value])
            cell.configure(viewModel:viewModel)
        }
        
        return cell
    }
}

