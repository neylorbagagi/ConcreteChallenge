//
//  CollectionBackgroundView.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 03/11/21.
//

import UIKit

class CollectionBackgroundView: UIView {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image?.withTintColor(#colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1))
        imageView.tintColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        imageView.contentMode = .center
        return imageView
    }()
    
    var message:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProText-Regular", size: 24)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        return label
    }()
    
    /// TODO: build this component with viewModel init(frame: CGRect,viewModel: TYPE)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.message)
                
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 200),
            self.imageView.widthAnchor.constraint(equalToConstant: 200),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -50),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.message.widthAnchor.constraint(equalToConstant: 300),
            self.message.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.message.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel:CollectionBackgroundViewModel){
        self.message.text = viewModel.message
        self.imageView.image = viewModel.image
    }
    
}
