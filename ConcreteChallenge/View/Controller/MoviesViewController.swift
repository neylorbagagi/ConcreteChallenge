//
//  ViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import UIKit

class MoviesViewController: UIViewController {

    private var viewModel: MoviesViewModel

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for movie title"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCollectionCell")
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 6
        collectionView.register(SupplementaryReusableView.self,
                                forSupplementaryViewOfKind: "bottom", withReuseIdentifier: "viewForSupplementary")
        return collectionView
    }()

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Movies"
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        self.view.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.configure(viewModel: self.viewModel)
    }

    private func configure(viewModel: MoviesViewModel) {

        self.viewModel = viewModel

        Cache.share.subscribe({ _ in
            self.collectionView.reloadData()
        })

        viewModel.data.observer = { data in
            guard let data = data else { return }

            DispatchQueue.main.async {
                self.collectionView.backgroundView = self.manageBackgroundView(
                    for: self.collectionView,
                    onSearch: self.searchController.searchBar.isFirstResponder,
                    dataIsEmpty: data.isEmpty)

                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }

        self.collectionView.dataSource = viewModel

        viewModel.requestData()
        self.collectionView.backgroundView = self.manageBackgroundView(
            for: self.collectionView,
            onSearch: false,
            onDataRequest: true,
            dataIsEmpty: true)
    }

    func manageBackgroundView(for view: UIView,
                              onSearch searchState: Bool = false,
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

        if isEmpty && requestState {
            let backgroundViewModel = ControllerBackgroundViewModel(type: .loadingData)
            controllerBackground?.configure(viewModel: backgroundViewModel)
        }

        if isEmpty && !searchState && !requestState {
            let backgroundViewModel = ControllerBackgroundViewModel(type: .loadDataFail)
            controllerBackground?.configure(viewModel: backgroundViewModel)
        }

        return controllerBackground
    }
}

extension MoviesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let dataSource = collectionView.dataSource as? MoviesViewModel,
              let movie = dataSource.collectionSelectedData(indexPath) else {
            print("Invalid DataSourve for CollectionView")
            return
        }

        let detaiViewModel = MovieDetailViewModel(movie: movie)
        let detailViewController = MovieDetailViewController(viewModel: detaiViewModel)
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {

        if collectionView.visibleCells.isEmpty || self.searchController.searchBar.isFirstResponder {
            view.removeFromSuperview()
        }

        guard let dataSource = collectionView.dataSource as? MoviesViewModel else {
            print("Invalid DataSourve for CollectionView")
            return
        }

        if !dataSource.isReachPageLimit && !collectionView.visibleCells.isEmpty {
            DispatchQueue(label: "requestDataOnBottom", qos: .background).async {
                dataSource.requestData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        view.removeFromSuperview()
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        self.viewModel.searchData(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.searchTextField.text = ""
        searchBar.showsCancelButton = false
        self.viewModel.stopSearchData()
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {

    private var sectionInsets: UIEdgeInsets {
        if UIDevice.current.model.contains("iPad") {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    private var itemsPerRow: CGFloat {
        if UIDevice.current.model.contains("iPad") {
            return 4
        }
        return 3
    }
    private var itemsPerColumn: CGFloat {
        if UIDevice.current.model.contains("iPad") {
            return 5
        }
        return 4
    }

    private var itemsOriginalWidth: CGFloat { return 210 } /// Using the original size of the poster
    private var itemsOriginalHeight: CGFloat { return 295 } /// Using the original size of the poster
    private var footerInSectionSize: CGFloat { return 59 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        /// ??? find out origin of this value:4
        let collectionWidth = collectionView.frame.width - 4

        /// Calculate width
        let widthPaddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
        let widthAvailable = collectionWidth - widthPaddingSpace
        let widthForItem = widthAvailable/self.itemsPerRow

        /// Calculate height proportion by its width
        /// Formula (original height / original width) x new width = new height
        let heightForItem = (self.itemsOriginalHeight/self.itemsOriginalWidth)*widthForItem
        return CGSize(width: widthForItem, height: heightForItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.top
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.footerInSectionSize)
    }
}
