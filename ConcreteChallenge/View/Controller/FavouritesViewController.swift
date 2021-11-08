//
//  FavouritesViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import UIKit

class FavouritesViewController: UIViewController {

    var viewModel:FavouritesViewModel?
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        tableView.register(FavouriteTableCell.self, forCellReuseIdentifier: "favouritesTableCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none;
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for movie title in favourites"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure appearence
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        navigationItem.title = "Favourites"
        // Do any additional setup after loading the view.
        
        self.viewModel = FavouritesViewModel()
        
        self.navigationItem.searchController = self.searchController
        self.view.addSubview(self.tableView)
        
        
        
        self.configure(viewModel:self.viewModel!)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func configure(viewModel:FavouritesViewModel) {
        
        viewModel.data.observer = { data in
            self.tableView.reloadData()
        }
        
        viewModel.requestData()
        
    }
    
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        guard let movie = viewModel?.selectedData(indexPath) else {return}
        
        let viewModel = MovieDetailViewModel(movie: movie)
        let detailViewController = MovieDetailViewController()
        detailViewController.configure(viewModel: viewModel)
        
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

extension FavouritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        self.viewModel?.searchData(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.searchTextField.text = ""
        searchBar.showsCancelButton = false
        self.viewModel?.stopSearchData()
    }
}
