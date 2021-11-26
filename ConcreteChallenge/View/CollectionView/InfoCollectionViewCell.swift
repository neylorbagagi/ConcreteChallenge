//
//  InfoCollectionViewCell.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 06/11/21.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    var viewModel:InfoCellViewModel?
    
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    var title:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.textColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        return label
    }()
    
    var value:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "SFProText-Bold", size: 22)
        label.textColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        label.numberOfLines = 4;
        label.minimumScaleFactor = 0.33;
        label.adjustsFontSizeToFitWidth = true;
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8078431373, blue: 0.3568627451, alpha: 1)
        self.layer.cornerRadius = 6
        
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(UIView())
        self.stackView.addArrangedSubview(self.title)
        self.stackView.addArrangedSubview(self.value)
        self.stackView.addArrangedSubview(UIView())
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            self.title.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.title.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.5),
            
            self.value.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.value.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.value.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.5),
            
        ])
        
    }
    
    func configure(viewModel:InfoCellViewModel) {
        self.title.text = viewModel.title
        self.value.text = viewModel.value
        
    }
    
    override func prepareForReuse() {
        self.title.text = ""
        self.value.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
