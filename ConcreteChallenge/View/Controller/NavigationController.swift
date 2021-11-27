//
//  NavigationController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        navigationBar.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        navigationBar.prefersLargeTitles = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                UIColor(named: "theme_accent") ?? #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)]
    }
}
