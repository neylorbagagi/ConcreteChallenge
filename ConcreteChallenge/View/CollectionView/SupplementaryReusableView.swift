//
//  SupplementaryReusableView.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 21/11/21.
//

import UIKit

enum SupplementaryReusableViewStyle {
    case requestingData
    case reachedDataLimit
}

class SupplementaryReusableView: UICollectionReusableView {

    var style: SupplementaryReusableViewStyle?

    var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.color = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        activityView.isHidden = true
        return activityView
    }()

    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProText-Regular", size: 18)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1882352941, blue: 0.2784313725, alpha: 1)
        label.text = "That's all Folks!" // Quoting Looney toones! : ]
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.activityView)
        self.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.activityView.topAnchor.constraint(equalTo: self.topAnchor),
            self.activityView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.activityView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.activityView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.label.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        self.activityView.isHidden = true
        self.label.isHidden = true
    }

    func configure(style: SupplementaryReusableViewStyle) {
        self.style = style
        if style == .reachedDataLimit {
            self.label.isHidden = false
            self.activityView.isHidden = true
        } else {
            self.label.isHidden = true
            self.activityView.isHidden = false
            self.activityView.startAnimating()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
