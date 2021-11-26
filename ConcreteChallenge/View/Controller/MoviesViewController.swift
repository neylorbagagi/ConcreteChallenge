//
//  ViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import UIKit

class MoviesViewController: UIViewController{

    var viewModel:MoviesViewModel?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for movie title"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self.viewModel
        collectionView.layer.cornerRadius = 6
        collectionView.register(SupplementaryReusableView.self, forSupplementaryViewOfKind: "bottom", withReuseIdentifier: "viewForSupplementary")
        return collectionView
    }()
    
    var activityView:UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Movies"
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        // Configure data
        self.viewModel = MoviesViewModel()
        self.configure(viewModel: self.viewModel!)
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    
    func configure(viewModel:MoviesViewModel){
                
        Cache.share.subscribe({ movies in
            self.collectionView.reloadData()
        })
        
        viewModel.data.observer = { data in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if self.activityView.isAnimating{
                    self.activityView.stopAnimating()
                    self.collectionView.backgroundView = nil
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.manageCollectionBackgroundView(collectionData: data.isEmpty)
            }
        }
        
        viewModel.requestData()
        self.collectionView.backgroundView = self.activityView
        self.activityView.startAnimating()
        
        
    }
    
    func manageCollectionBackgroundView(collectionData isEmpty:Bool) {
        
        if !isEmpty {
            self.collectionView.backgroundView = nil
        }
        
        if isEmpty && self.searchController.searchBar.isFirstResponder {

            let backgroundView = CollectionBackgroundView(frame: self.collectionView.frame)
            let viewModel = CollectionBackgroundViewModel(type: .searchDataEmpty)
            backgroundView.configure(viewModel: viewModel)
            self.collectionView.backgroundView = backgroundView

        }

        if isEmpty && !self.searchController.searchBar.isFirstResponder {

            let backgroundView = CollectionBackgroundView(frame: self.collectionView.frame)
            let viewModel = CollectionBackgroundViewModel(type: .loadDataFail)
            backgroundView.configure(viewModel: viewModel)
            self.collectionView.backgroundView = backgroundView

        }
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let movie = viewModel?.collectionSelectedData(indexPath) else {return}
        
        let viewModel = MovieDetailViewModel(movie: movie)
        let detailViewController = MovieDetailViewController()
        detailViewController.configure(viewModel: viewModel)
        
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView,
                                                                   forElementKind elementKind: String, at indexPath: IndexPath) {

        if collectionView.visibleCells.isEmpty || self.searchController.searchBar.isFirstResponder {
            view.removeFromSuperview()
        }
        
        guard let viewModel = self.viewModel else { return }
        
        if !viewModel.reachPageLimit && !collectionView.visibleCells.isEmpty { /// doing the same at ViewModel line 22
            
            DispatchQueue(label: "requestDataOnBottom", qos: .background).async {
                viewModel.requestData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        view.removeFromSuperview()
    }
    
    
}

extension MoviesViewController: UISearchBarDelegate {
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

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    /// ???  Make this code more elegant
    private var sectionInsets:UIEdgeInsets {
        if UIDevice.current.model.contains("iPad") {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    private var itemsPerRow:CGFloat {
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
    
    private var itemsOriginalWidth:CGFloat { return 210 } /// Using the original size of the poster
    private var itemsOriginalHeight:CGFloat { return 295 } /// Using the original size of the poster
    private var footerInSectionSize:CGFloat { return 59 }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.footerInSectionSize)
    }
    
    
    
    
}
