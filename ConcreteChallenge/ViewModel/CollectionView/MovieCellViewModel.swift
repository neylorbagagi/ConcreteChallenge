//
//  MovieCellViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import Foundation
import UIKit

class MovieCellViewModel: NSObject {

    private let data: Movie
    let title: String
    var poster: Bindable<UIImage> = Bindable<UIImage>()
    let isFavourite: Bool
    let basePath: String = "https://image.tmdb.org/t/p/w500"

    init(movie: Movie) {
        self.data = movie
        self.title = movie.title
        self.isFavourite = Cache.share.checkFavouriteState(movie: movie)
    }
    func requestImage() {
        if let cachedImage = Cache.share.images.object(forKey: self.data.posterPath as AnyObject) {
            self.poster.value = cachedImage
            return
        }

        DispatchQueue.init(label: "imageLoading", qos: .background).async {
            guard let url = URL(string: self.basePath+(self.data.posterPath ?? "")) else {
                print("invalid url")
                return
            }

            do {
                let imageData = try Data(contentsOf: url)
                guard let image = UIImage(data: imageData) else { return }
                Cache.share.images.setObject(image, forKey: self.data.posterPath as AnyObject)
                self.poster.value = image
            } catch let error {
                print("imageerror: \(error.localizedDescription)")
            }
        }
    }
}
