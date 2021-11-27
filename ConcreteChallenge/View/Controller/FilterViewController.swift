//
//  FilterViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import UIKit

class FilterViewController: UIViewController {

    var viewModel: FilterViewModel
    var onSetCriteria:((_ data: [Movie], _ criteria: Criteria) -> Void)?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        tableView.backgroundColor = #colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        tableView.register(FilterTableCell.self, forCellReuseIdentifier: "filterTableCell")
        return tableView
    }()

    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply Filter", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1), for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        button.addTarget(self, action: #selector(updateCriteria), for: .touchDown)
        return button
    }()

    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure appearence
        navigationItem.title = "Filters"

        self.view.addSubview(self.tableView)
        self.view.addSubview(self.applyButton)
        self.configure(viewModel: self.viewModel)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.applyButton.topAnchor),

            self.applyButton.topAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            self.applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22),
            self.applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22),
            self.applyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -22),
            self.applyButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    func configure(viewModel: FilterViewModel) {
        viewModel.genres.observer = { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        viewModel.criteria.observer = { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func updateCriteria() {
        guard let criteria = viewModel.criteria.value else { return }
        self.navigationController?.popViewController(animated: true)
        self.onSetCriteria?(viewModel.filteredData, criteria)
    }
}

extension FilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let filterTerm: FilterTerms = FilterTerms.allCases[indexPath.row]
        let registers: [AnyHashable] = self.viewModel.dataForCriteria(filterTerm: filterTerm)
        let selectedData: [AnyHashable]

        switch filterTerm {
        case .releaseDate:
            selectedData = self.viewModel.criteria.value?.releaseDate ?? []
        case .genre:
            selectedData = self.viewModel.criteria.value?.genre ?? []
        }

        let selectorViewModel: SelectorViewModel<AnyHashable> = SelectorViewModel(data: registers,
                                                                                  selectedData: selectedData,
                                                                                  filterTerm: filterTerm)

        let selectorViewController = SelectorViewController(viewModel: selectorViewModel)
        selectorViewController.modalPresentationStyle = .fullScreen
        selectorViewController.onSelected = { value, term in
            self.viewModel.updateCriteria(value: value, filterTerm: term)
        }

        self.navigationController?.pushViewController(selectorViewController, animated: true)
    }
}
