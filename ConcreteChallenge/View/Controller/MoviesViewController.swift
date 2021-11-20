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
        
        // Configure appearence
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
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
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.requestData()
    }
    
    func configure(viewModel:MoviesViewModel){
                
        viewModel.data.observer = { data in
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                if self.activityView.isAnimating{
                    self.activityView.stopAnimating()
                }
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.manageCollectionBackgroundView(collectionData: data.isEmpty)
            }
        }
        
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
        detailViewController.onFavouriteChange = { state in
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
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
    
    private var sectionInsets:UIEdgeInsets { return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) }
    private var itemsPerRow:CGFloat { return 3 }
    private var itemsPerColumn: CGFloat { return 4}
    private var itemsOriginalWidth:CGFloat { return 210 } /// Using the original size of the poster
    private var itemsOriginalHeight:CGFloat { return 295 } /// Using the original size of the poster
    private var footerInSectionSize:CGFloat { return 75 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        /// TODO: find out origin of this value:4
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
