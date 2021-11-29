//
//  MovieDetailViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import Foundation
import UIKit

enum MovieDetailViewModelInfoKey: String, CaseIterable {
    case voteAverage = "Vote Average"
    case voteCount = "Votes Count"
    case releaseDate = "Release Date"
    case popularity = "Popularity Rate"
    case originalLanguage = "Original Language"
    case adult = "Adult Content?"
}

class MovieDetailViewModel: NSObject {

    private let data: Movie
    let title: String
    let originalTitle: String
    let releaseDate: String
    let overview: String
    let voteAverage: String
    let voteCount: String
    let popularity: String
    let adult: String
    let originalLanguage: String
    var backdrop: Bindable<UIImage> = Bindable<UIImage>()
    var genres: Bindable<String> = Bindable<String>()
    var info: Bindable<[MovieDetailViewModelInfoKey: String]> = Bindable<[MovieDetailViewModelInfoKey: String]>()
    var isFavourite: Bindable<Bool> = Bindable<Bool>(false)

    init(movie: Movie) {
        self.data = movie
        self.title = movie.title
        self.originalTitle = "(\(movie.originalTitle))"
        self.releaseDate = String(movie.releaseDate.split(separator: "-").first ?? "UNKNOW")
        self.overview = movie.overview
        self.voteAverage = String(movie.voteAverage)
        self.voteCount = MovieDetailViewModel.formatPoints(from: movie.voteCount)
        self.genres.value = "N/A"

        let popularityString = String(movie.popularity)
        self.popularity = String(popularityString.split(separator: ".").first ?? "0") // let's make it more readable
        self.adult = movie.adult ? "YES" : "NO"
        self.originalLanguage = movie.originalLanguage
        self.info.value = [.voteAverage: self.voteAverage, .voteCount: self.voteCount,
                     .releaseDate: self.releaseDate, .popularity: self.popularity,
                     .originalLanguage: self.originalLanguage, .adult: self.adult]
    }

    func requestFavouriteState() {

        Cache.share.subscribe({ movies in
            if movies.contains(where: { $0.id == self.data.id}) {
                self.isFavourite.value = true
            } else {
                self.isFavourite.value = false
            }
        })

        self.isFavourite.value = Cache.share.checkFavouriteState(movie: self.data)
    }

    func requestImage() {

        if let cachedImage = Cache.share.images.object(forKey: self.data.backdropPath as AnyObject) {
            self.backdrop.value = cachedImage
            return
        }

        DispatchQueue.init(label: "imageLoading", qos: .background).async {
            let basePath = "https://image.tmdb.org/t/p/w500"

            guard let url = URL(string: basePath+(self.data.backdropPath ?? "")) else {
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

    func requestGenres() {
        DispatchQueue.init(label: "genresLoading", qos: .background).async {

            APIClient.share.getGenres { (result) in
                switch result {
                case .success(let data):
                    self.genres.value = self.composeGenreDescription(genres: data)
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
    }

    private func composeGenreDescription(genres: [Genre]) -> String {

        var composedGenres: [String] = []

        for id in self.data.genreIDS {
            if let genderName = genres.first(where: {$0.id == id})?.name {
                composedGenres.append(genderName)
            }
        }

        return composedGenres.joined(separator: ", ")

    }

    func updateMovieFavouriteState(to state: Bool) throws {
        if !state {
            do {
                try Cache.share.save(movie: self.data)
            } catch let error {
                print("\(error)")
            }
        } else {
            do {
                try Cache.share.delete(movie: self.data)
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

extension MovieDetailViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MovieDetailViewModelInfoKey.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCollectionCell",
                                                      for: indexPath) as? InfoCollectionViewCell

        let currentKey = MovieDetailViewModelInfoKey.allCases[indexPath.row]

        let key = currentKey.rawValue
        if let value = self.info.value?[currentKey] {
            let viewModel = InfoCellViewModel(info: [key: value])
            cell?.configure(viewModel: viewModel)
        }

        return cell ?? UICollectionViewCell()
    }
}
