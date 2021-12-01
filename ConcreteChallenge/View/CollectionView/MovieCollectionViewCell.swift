//
//  MovieCollectionViewCell.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        return imageView
    }()

    private var title: UILabel = {
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

    private var favouriteView: UIImageView = {
        let image = UIImage(named: "fav_selected")?.withTintColor(#colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1))
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.layer.shadowColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowOpacity = 0.9
        imageView.layer.shadowRadius = 2.0
        imageView.clipsToBounds = false
        imageView.isHidden = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.favouriteView)

        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.title.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.favouriteView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.favouriteView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.favouriteView.heightAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 1/6),
            self.favouriteView.widthAnchor.constraint(equalTo: self.favouriteView.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.imageView.image = nil
        self.favouriteView.isHidden = true
    }

    func configure(viewModel: MovieCellViewModel) {
        self.title.text = viewModel.title
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true

        if viewModel.isFavourite {
            self.favouriteView.isHidden = false
        }

        viewModel.poster.observer = { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

        viewModel.requestImage()
    }
}
