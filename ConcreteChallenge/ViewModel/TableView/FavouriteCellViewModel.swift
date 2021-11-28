//
//  FavouriteCellViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 07/11/21.
//

import Foundation
import UIKit
class FavouriteCellViewModel: NSObject {

    private let data: Movie
    let title: String
    let releaseDate: String
    let overview: String
    var poster: Bindable<UIImage> = Bindable<UIImage>()
    let basePath: String

    init(data: Movie) {
        self.data = data
        self.title = data.title
        self.releaseDate = String(data.releaseDate.split(separator: "-").first ?? "UNKNOW")
        self.overview = data.overview
        self.basePath = "https://image.tmdb.org/t/p/w500"
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
                print(error.localizedDescription)
            }
        }
    }
}
