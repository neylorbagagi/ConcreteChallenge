//
//  MovieDetailViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 05/11/21.
//

/// TODO: fix erro that dont allow to update favourite from favourites > details

import UIKit

class MovieDetailViewController: UIViewController {

    var viewModel:MovieDetailViewModel? = nil
    //var onFavouriteChange:((_ buttonState:Bool)->Void)?
    
    var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 6
        return scrollView
    }()
    
    var contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true // this keeps cornerRadius property
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        return imageView
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProText-Bold", size: 32)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        return label
    }()
    
    var originalTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProText-Thin", size: 14)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        return label
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: collectionLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12);
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        collectionView.backgroundColor = .white
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "infoCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self.viewModel
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
       
    var textView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .none
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.textAlignment = .natural
        textView.isScrollEnabled = false;
        textView.font = UIFont(name: "SFProText-Regular", size: 16)
        textView.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        return textView
    }()
    
    private lazy var button:UIButton = {
        let icon_default = UIImage(named: "fav_unselected")?.withTintColor(#colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1))
        let icon_selected = UIImage(named: "fav_selected")?.withTintColor(#colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1))
        
        let button = UIButton()
        button.addTarget(self, action: #selector(didTouchFavourite), for: .touchDown)
        button.setImage(icon_default, for: .normal)
        button.setImage(icon_selected, for: .selected)
        button.isSelected = false
        return button
    }()
    
    private var favBarButtonItem:UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        return barButtonItem
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favBarButtonItem.customView = self.button
        self.navigationItem.rightBarButtonItem = self.favBarButtonItem
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.originalTitle)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.textView)
        
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 9/16),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 16),
            self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.originalTitle.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -4),
            self.originalTitle.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 18),
            self.originalTitle.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.collectionView.topAnchor.constraint(equalTo: self.originalTitle.bottomAnchor, constant: 8),
            self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 91),
            
            self.textView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 4),
            self.textView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.textView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            
        ])
    }
    
    func configure(viewModel:MovieDetailViewModel) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.title
        self.originalTitle.text = viewModel.originalTitle
        self.textView.text = viewModel.overview
        
        viewModel.isFavourite.observer = { state in
            self.button.isSelected = state!
        }
        viewModel.requestFavouriteState()
        
        viewModel.backdrop.observer = { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        viewModel.requestImage()
        
        viewModel.info.observer = { dict in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        viewModel.requestGenres()
    }

    @objc private func didTouchFavourite(){
        
        do {
            try self.viewModel?.updateMovieFavouriteState(to: self.button.isSelected)
        } catch let error {
            print("Error during data update: \(error)")
        }
        
        
        /// maybe it doesn't work, both detail and main view will be listening
        //guard let onFavouriteChange = self.onFavouriteChange else { return }
        
        
        /// If unsuccessful to update do not call onFavouriteChange
//        do {
//            try self.viewModel?.updateMoviewFavouriteState(to: self.button.isSelected)
//            self.button.isSelected.toggle()
//            onFavouriteChange(self.button.isSelected)
//        } catch let error {
//            print("Error during data update: \(error)")
//        }
    }
}


extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    private var sectionInsets:UIEdgeInsets { return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        /// let collectionWidth = collectionView.frame.width
        let collectionHeigh = collectionView.frame.height
        
        /// Calculate width
        /// Using a porpotion of 3/4 to calculate from height
        let widthForItem = (3/4)*collectionHeigh
        let heightForItem = collectionHeigh - (sectionInsets.top + sectionInsets.bottom)
        
        return CGSize(width: widthForItem, height: heightForItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
    
}
