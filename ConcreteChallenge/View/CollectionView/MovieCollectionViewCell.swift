//
//  MovieCollectionViewCell.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    var viewModel:MovieCellViewModel?
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        return imageView
    }()
    
    var title:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProText-Thin", size: 14)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.title)
        self.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.title.topAnchor.constraint(equalTo: self.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
    }
    
    func configure(viewModel:MovieCellViewModel) {
        self.title.text = viewModel.title
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        
        viewModel.poster.observer = { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        viewModel.requestImage()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
