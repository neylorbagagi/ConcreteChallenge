//
//  CollectionBackgroundViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 03/11/21.
//

import Foundation
import UIKit

enum CollectionBackgroundType {
    case searchDataNotFound
    case loadDataFail
}

class CollectionBackgroundViewModel:NSObject {
    
    let image:UIImage
    let message:String
    
    init(type:CollectionBackgroundType) {
        switch type {
        case .searchDataNotFound:
            self.message = "Sua busca não obteve resultado."
            self.image = UIImage(named: "search")?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)) ?? UIImage()
        default:
            self.message = "Um erro ocorreu. Por Favor, tente novamente."
            self.image = UIImage(named: "error")?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)) ?? UIImage()
        }
    }
    
}
