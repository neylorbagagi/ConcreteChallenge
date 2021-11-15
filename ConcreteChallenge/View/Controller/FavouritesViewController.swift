//
//  FavouritesViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import UIKit

/// TODO: evaluate all ! in code

class FavouritesViewController: UIViewController {

    var viewModel:FavouritesViewModel?
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        tableView.register(FavouriteTableCell.self, forCellReuseIdentifier: "favouritesTableCell")
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "favouritesTableCellHeader")
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
    
    private lazy var filterBarButtonItem:UIBarButtonItem = {
        let icon = UIImage(named: "filter_icon")
        let barButtonItem = UIBarButtonItem(image: icon,
                                            style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(presentFilter))
        
        return barButtonItem
    }()
    
    var activityView:UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure appearence
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        navigationItem.title = "Favourites"
        // Do any additional setup after loading the view.
        
        self.viewModel = FavouritesViewModel()
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.rightBarButtonItem = self.filterBarButtonItem
        
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
            
            if self.activityView.isAnimating{
                self.activityView.stopAnimating()
            }
            
            guard let data = data else { return }
            self.manageTableBackgroundView(collectionData: data.isEmpty)
        }
        
        self.tableView.backgroundView = self.activityView
        self.activityView.startAnimating()
        
        viewModel.requestData()
        
//        viewModel.data.observer = { data in
//            self.tableView.reloadData()
//        }
//
//        viewModel.requestData()
        
    }
    
    @objc func presentFilter(){
        
        guard let viewModel = self.viewModel else { return }
        
        /// We get getCacheData return 'cause we want that FilterViewModel works
        /// with full data not just data in current presentation status
        let data = viewModel.getCacheData()
        
        /// TODO: make all ViewControllers init from a viewMoodel
        let filterViewModel = FilterViewModel(data:data)
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        filterViewController.onSetCriteria = { data in
            viewModel.isFiltering = true
            viewModel.data.value = data
        }

        filterViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    func manageTableBackgroundView(collectionData isEmpty:Bool) {

        if !isEmpty {
            self.tableView.backgroundView = nil
            return
        }
        
        if isEmpty && self.searchController.searchBar.isFirstResponder {

            let backgroundView = CollectionBackgroundView(frame: self.tableView.frame)
            let viewModel = CollectionBackgroundViewModel(type: .searchDataEmpty)
            backgroundView.configure(viewModel: viewModel)
            self.tableView.backgroundView = backgroundView
            return
        }

        if isEmpty && self.viewModel?.isFiltering == true {

            let backgroundView = CollectionBackgroundView(frame: self.tableView.frame)
            let viewModel = CollectionBackgroundViewModel(type: .filterDataEmpty)
            backgroundView.configure(viewModel: viewModel)
            self.tableView.backgroundView = backgroundView
            return
        }
        
        if isEmpty && !self.searchController.searchBar.isFirstResponder {

            let backgroundView = CollectionBackgroundView(frame: self.tableView.frame)
            let viewModel = CollectionBackgroundViewModel(type: .loadDataFail)
            backgroundView.configure(viewModel: viewModel)
            self.tableView.backgroundView = backgroundView
            return
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var view:UIView?
        
        guard let viewModel = self.viewModel else {
            return view
        }
        
        if viewModel.isFiltering {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "favouritesTableCellHeader") as! TableViewHeaderView
            header.onRemoveCriteria = {
                viewModel.stopFilterData()
            }
            
            view = header
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height:CGFloat = .zero
        
        guard let viewModel = self.viewModel else {
            return  height
        }
        
        if viewModel.isFiltering {
            height = tableView.sectionHeaderHeight
        }
        
        return height
    }
}

extension FavouritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchData(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.stopSearchData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel?.stopFilterData()
    }
    
}
