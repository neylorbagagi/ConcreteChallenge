//
//  FavouriteTableCell.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 07/11/21.
//

import UIKit

class FavouriteTableCell: UITableViewCell {

    var viewModel:FavouriteCellViewModel?
    
    let posterView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let headerStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let title:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "SFProText-Bold", size: 22)
        label.textColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.7;
        label.adjustsFontSizeToFitWidth = true;
        return label
    }()
    
    let release:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: "SFProText-Thin", size: 18)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        return label
    }()
    
    let textView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.text = ""
        textView.textAlignment = .natural
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isScrollEnabled = false;
        textView.font = UIFont(name: "SFProText-Regular", size: 14)
        textView.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        return textView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(self.posterView)
        self.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerStackView)
        self.stackView.addArrangedSubview(self.textView)

        self.headerStackView.addArrangedSubview(self.title)
        self.headerStackView.addArrangedSubview(self.release)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 193),
            
            self.posterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.posterView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.posterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.posterView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2/3),
            
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.stackView.leftAnchor.constraint(equalTo: self.posterView.rightAnchor, constant: 16),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.stackView.heightAnchor.constraint(equalTo: self.posterView.heightAnchor, constant: -16),
            
            self.headerStackView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.4),
            self.textView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.6),
            
            self.title.widthAnchor.constraint(equalTo: self.headerStackView.widthAnchor, multiplier: 0.8),
            self.release.widthAnchor.constraint(equalTo: self.headerStackView.widthAnchor, multiplier: 0.7),
            
        ])
        
    }
    
    func configure(viewModel:FavouriteCellViewModel){
        
        self.title.text = viewModel.title
        self.release.text = viewModel.releaseDate
        self.textView.text = viewModel.overview
        
        viewModel.poster.observer = { image in
            DispatchQueue.main.async {
                self.posterView.image = image
            }
        }
        
        viewModel.requestImage()
    }
    
    override func prepareForReuse() {
        self.posterView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
