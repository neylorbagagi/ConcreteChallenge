//
//  CollectionBackgroundViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 03/11/21.
//

import Foundation
import UIKit

enum ControllerBackgroundViewType {
    case searchDataEmpty
    case filterDataEmpty
    case loadDataFail
    case loadDataEmpty
    case loadingData
}

class ControllerBackgroundViewModel: NSObject {

    let image: UIImage
    let message: String
    let activityViewShouldAnimate: Bool
    let type: ControllerBackgroundViewType

    init(type: ControllerBackgroundViewType) {

        self.type = type
        switch type {
        case .searchDataEmpty:
            self.message = "Sua busca não obteve resultado."
            self.image = UIImage(named: "search")?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)) ?? UIImage()
            self.activityViewShouldAnimate = false
        case .filterDataEmpty:
            self.message = "Seu filtro não obteve resultado."
            self.image = UIImage(named: "filter")?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)) ?? UIImage()
            self.activityViewShouldAnimate = false
        case .loadDataEmpty:
            self.message = "Favorite filmes para ve-los aqui."
            self.image = UIImage(named: "empty")?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)) ?? UIImage()
            self.activityViewShouldAnimate = false
        case .loadingData:
            self.message = "Carregando..."
            self.image = UIImage()
            self.activityViewShouldAnimate = true
        default:
            self.message = "Um erro ocorreu. Por Favor, tente novamente."
            self.image = UIImage(named: "error")?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)) ?? UIImage()
            self.activityViewShouldAnimate = false
        }
    }
}
