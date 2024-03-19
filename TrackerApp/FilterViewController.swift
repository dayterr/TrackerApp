//
//  FilterViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 17.03.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func selectedFilters(filter: Filter)
}

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    var selectedFilter = Filter.allTrackers
    
    private var filters = Filter.allCases.map { $0.rawValue }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.backgroundColor = .ypWhite
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterViewCell")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        title = "Фильтры"
        view.addSubview(tableView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath)
        cell.backgroundColor = .ypGrayHex
        cell.selectionStyle = .none
        cell.textLabel?.text = filters[indexPath.row]
        if Filter.allCases[indexPath.row] == selectedFilter {
            cell.accessoryType = .checkmark
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedFilters(filter: Filter.allCases[indexPath.row])
        dismiss(animated: true)
    }
}
