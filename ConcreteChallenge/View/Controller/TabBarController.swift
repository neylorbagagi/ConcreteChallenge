//
//  TabBarViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Appearance
        self.selectedIndex = 0
        self.tabBar.barTintColor = #colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1)
        self.tabBar.tintColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = #colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1)

        self.configure()
    }

    private func configure() {

        let movieTabItem = UITabBarItem.init(tabBarSystemItem: .mostViewed, tag: 0)
        movieTabItem.title = "Moviews"

        let favouritesTabItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        favouritesTabItem.title = "Favourites"

        let moviesViewModel = MoviesViewModel()
        let moviesViewController = MoviesViewController(viewModel: moviesViewModel)

        let favouritesViewModel = FavouritesViewModel()
        let favouritesViewController = FavouritesViewController(viewModel: favouritesViewModel)

        let moviesNavigationController = NavigationController(rootViewController: moviesViewController)
        moviesNavigationController.tabBarItem = movieTabItem

        let favouritesNavigationController = NavigationController(rootViewController: favouritesViewController)
        favouritesNavigationController.tabBarItem = favouritesTabItem

        self.viewControllers = [moviesNavigationController, favouritesNavigationController]
    }
}
