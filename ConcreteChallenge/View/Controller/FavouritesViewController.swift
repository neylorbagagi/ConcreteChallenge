//
//  FavouritesViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

import UIKit

class FavouritesViewController: UIViewController {

    var viewModel: FavouritesViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.register(FavouriteTableCell.self, forCellReuseIdentifier: "favouritesTableCell")
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "favouritesTableCellHeader")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
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

    private lazy var filterBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(named: "filter_icon")
        let barButtonItem = UIBarButtonItem(image: icon,
                                            style: .plain,
                                           target: self,
                                           action: #selector(didButtonTouch))
        return barButtonItem
    }()

    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure appearence
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        navigationItem.title = "Favourites"

        self.navigationItem.searchController = self.searchController
        self.navigationItem.rightBarButtonItem = self.filterBarButtonItem
        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.configure(viewModel: self.viewModel)
    }

    private func configure(viewModel: FavouritesViewModel) {

        self.viewModel = viewModel

        viewModel.data.observer = { data in
            self.tableView.reloadData()

            guard let data = data else { return }
            self.tableView.backgroundView = self.manageBackgroundView(
                for: self.tableView,
                onSearch: self.searchController.searchBar.isFirstResponder,
                onFilter: self.viewModel.isFiltering,
                onDataRequest: false,
                dataIsEmpty: data.isEmpty)
        }

        self.tableView.dataSource = viewModel
        self.tableView.backgroundView = self.manageBackgroundView(
            for: self.tableView,
            onSearch: self.searchController.searchBar.isFirstResponder,
            onFilter: self.viewModel.isFiltering,
            onDataRequest: true,
            dataIsEmpty: false)

        viewModel.requestData()
    }

    @objc private func didButtonTouch() {
        self.presentFilter(viewModel: self.viewModel)
    }

    private func presentFilter(viewModel: FavouritesViewModel) {

        let criteria = viewModel.criteria
        let data = viewModel.getCacheData()

        let filterViewModel = FilterViewModel(data: data, criteria: criteria)
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        filterViewController.onSetCriteria = { data, criteria in
            viewModel.isFiltering = true
            viewModel.criteria = criteria
            viewModel.data.value = data
        }

        filterViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }

    func manageBackgroundView(for view: UIView,
                              onSearch searchState: Bool = false,
                              onFilter filterState: Bool = false,
                              onDataRequest requestState: Bool = false,
                              dataIsEmpty isEmpty: Bool) -> ControllerBackgroundView? {

        var controllerBackground: ControllerBackgroundView? = ControllerBackgroundView(frame: view.frame)

        if !isEmpty {
            controllerBackground = nil
        }

        if isEmpty && searchState {
            let backgroundViewModel = ControllerBackgroundViewModel(type: .searchDataEmpty)
            controllerBackground?.configure(viewModel: backgroundViewModel)
        }

        if isEmpty && filterState {
            let backgroundViewModel = ControllerBackgroundViewModel(type: .filterDataEmpty)
            controllerBackground?.configure(viewModel: backgroundViewModel)
        }

        if isEmpty && requestState {
            let backgroundViewModel = ControllerBackgroundViewModel(type: .loadingData)
            controllerBackground?.configure(viewModel: backgroundViewModel)
        }

        if isEmpty && !searchState && !filterState {
            let backgroundViewModel = ControllerBackgroundViewModel(type: .loadDataEmpty)
            controllerBackground?.configure(viewModel: backgroundViewModel)
        }

        return controllerBackground
    }
}

extension FavouritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = tableView.dataSource as? FavouritesViewModel,
              let movie = dataSource.selectedData(indexPath) else {
            print("Invalid DataSource for TableView")
            return
        }
        let detailViewModel = MovieDetailViewModel(movie: movie)
        let detailViewController = MovieDetailViewController(viewModel: detailViewModel)
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: UIView?

        guard let dataSource = tableView.dataSource as? FavouritesViewModel else {
            print("Invalid DataSource for TableView")
            return UIView()
        }

        if dataSource.isFiltering {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "favouritesTableCellHeader")
                as? TableViewHeaderView
            header?.onRemoveCriteria = {
                dataSource.stopFilterData()
            }
            view = header
        }

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        var height: CGFloat = .zero
        guard let dataSource = tableView.dataSource as? FavouritesViewModel else {
            print("Invalid DataSource for TableView")
            return height
        }

        if dataSource.isFiltering {
            height = tableView.sectionHeaderHeight
        }

        return height
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

        if self.searchController.searchBar.isFirstResponder {
            return .none
        }
        return .delete
    }
}

extension FavouritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchData(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel.stopSearchData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel.stopFilterData()
    }
}
