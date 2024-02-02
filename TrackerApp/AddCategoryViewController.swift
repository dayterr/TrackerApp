//
//  AddCategoryViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 23.01.2024.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategory: TrackerCategory?)
}


final class AddCategoryViewController: UIViewController {
    
    weak var delegate: AddCategoryViewControllerDelegate?
    var category: TrackerCategory?
    
    private let mockDataCategory = TrackerCategory(name: "MockDataCategory", trackersList: [])
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mainBaseImage"))
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var categoriesList: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        categoriesList.register(UITableViewCell.self, forCellReuseIdentifier: "CategoriesList")
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Категория"
        view.addSubview(addCategoryButton)
        
        if TrackersViewController().categories.isEmpty {
            view.addSubview(placeholderImageView)
            view.addSubview(placeholderLabel)
        } else {
            view.addSubview(categoriesList)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.widthAnchor.constraint(equalToConstant: 335),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        if TrackersViewController().categories.isEmpty {
            NSLayoutConstraint.activate([
                placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
                placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
                placeholderImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 261),
                placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
                placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        } else {
            NSLayoutConstraint.activate([
                categoriesList.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
                categoriesList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                categoriesList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                categoriesList.heightAnchor.constraint(equalToConstant: CGFloat(75 * TrackersViewController().categories.count))
            ])
            categoriesList.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @objc private func didTapAddCategoryButton() {
        delegate?.updateNewCategory(newCategory: mockDataCategory)
        categoriesList.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackersViewController().categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesList.dequeueReusableCell(withIdentifier: "CategoriesList", for: indexPath)
        cell.textLabel?.text = TrackersViewController().categories[indexPath.row].name
        cell.backgroundColor = UIColor(named: "LightGrey")
        return cell
    }
}
