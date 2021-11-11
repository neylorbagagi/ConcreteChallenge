//
//  FilterViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import UIKit

class FilterViewController: UIViewController {

    var viewModel:FilterViewModel
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        tableView.backgroundColor = #colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1)
        return tableView
    }()
    
    init(viewModel:FilterViewModel) {
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
        
        self.configure(viewModel: self.viewModel)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        // Do any additional setup after loading the view.
    }
    
    func configure(viewModel:FilterViewModel){
        viewModel.criteria.observer = { value in
            self.tableView.reloadData()
        }
    }
    
}

extension FilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let filterTerm:FilterTerms = FilterTerms.allCases[indexPath.row]
        
        /// TODO: AnyHashable could be converted to Hashable
        let registers:[AnyHashable] = self.viewModel.dataForCriteria(filterTerm: filterTerm)
        let selectedData:[AnyHashable]
        
        switch filterTerm {
        case .releaseDate:
            selectedData = self.viewModel.criteria.value?.releaseDate ?? []
        case .genre:
            selectedData = self.viewModel.criteria.value?.genre ?? []
        }
        
        let selectorViewModel:SelectorViewModel<AnyHashable> = SelectorViewModel(data:registers,
                                                                                 selectedData:selectedData,
                                                                           filterTerm:filterTerm)
        
        let selectorViewController = SelectorViewController(viewModel: selectorViewModel)
        selectorViewController.modalPresentationStyle = .fullScreen
        selectorViewController.onSelected = { value, term in
            self.viewModel.updateCriteria(value: value, filterTerm: term)
        }
        
        self.navigationController?.pushViewController(selectorViewController, animated: true)
        
        
    }
    
}
