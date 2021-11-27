//
//  FilterTableCell.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 24/11/21.
//

import UIKit

class FilterTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(viewModel: FilterCellViewModel) {
        self.textLabel?.text = viewModel.title
        self.detailTextLabel?.text = viewModel.detail
    }
}
