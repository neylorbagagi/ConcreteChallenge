//
//  SelectorViewController.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 08/11/21.
//

import UIKit

class SelectorViewController: UIViewController {

    var viewModel:SelectorViewModel<AnyHashable>
    let filterTerm:FilterTerms
    var onSelected:((_ value:AnyHashable,_ filterTerm:FilterTerms)->Void)?
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 6
        tableView.delegate = self
        tableView.dataSource = self.viewModel
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = #colorLiteral(red: 0.9689999819, green: 0.8080000281, blue: 0.3569999933, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.175999999, green: 0.1879999936, blue: 0.2779999971, alpha: 1)
        return tableView
    }()
      
    
    init(viewModel:SelectorViewModel<AnyHashable>) {
        self.viewModel = viewModel
        self.filterTerm = viewModel.filterTerm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure appearence
        navigationItem.title = self.filterTerm.rawValue
        
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        // Do any additional setup after loading the view.
    }
    
}

extension SelectorViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let selectedData = viewModel.selectedCellValue(indexPath: indexPath)
        self.onSelected?(selectedData, self.filterTerm)
        
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        let selectedData = viewModel.selectedCellValue(indexPath: indexPath)
        self.onSelected?(selectedData, self.filterTerm)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.isSelected{
            
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
    }
}
