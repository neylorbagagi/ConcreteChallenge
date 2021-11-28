//
//  TableViewHeaderView.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 14/11/21.
//

import UIKit

class TableViewHeaderView: UITableViewHeaderFooterView {

    var button:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear Filter", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1), for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        button.addTarget(self, action: #selector(clearCriteria), for: .touchDown)
        return button
    }()
    
    var onRemoveCriteria:(() -> Void)?
    
    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configure()
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(self.button)
        
        NSLayoutConstraint.activate([
            self.button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            self.button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            self.button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            self.button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            self.button.heightAnchor.constraint(equalToConstant: 46),
        ])
    }
    
    @objc func clearCriteria() {
        guard let onRemoveCriteria = self.onRemoveCriteria else { return }
        onRemoveCriteria()
    }

}
