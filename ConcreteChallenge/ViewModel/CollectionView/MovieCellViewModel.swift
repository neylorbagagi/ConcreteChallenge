//
//  MovieCellViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import Foundation
import UIKit

class MovieCellViewModel:NSObject {
    
    private let data:Movie
    let title:String
    var poster:Bindable<UIImage> = Bindable<UIImage>()
    
    init(movie:Movie) {
        self.data = movie
        self.title = movie.title
    }
    
    func requestImage() {
        
        if let cachedImage = Cache.share.images.object(forKey: self.data.posterPath as AnyObject){
            self.poster.value = cachedImage
            return
        }
        
        DispatchQueue.init(label: "imageLoading", qos: .background).async {
            
            let base_path = "https://image.tmdb.org/t/p/w500"
            
            guard let url = URL(string: base_path+self.data.posterPath) else {
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
