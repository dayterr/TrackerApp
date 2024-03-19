//
//  CreateNewCategoryViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 03.03.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategory: TrackerCategory?)
}

final class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
    lazy var categoryViewModel = CategoryViewModel()
    private var category: TrackerCategory?
    
    private lazy var placeholderImage: UIImageView = {
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
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        applyConstraints()
        
        categoryViewModel.$listCategories.bind { [weak self] _ in
            guard let self else { return }
            self.showPlaceholder()
            self.categoriesList.reloadData()
        }
        
        categoryViewModel.$categoryChosen.bind { [weak self] _ in
            guard let self else { return }
            self.categoriesList.reloadData()
        }
    }
    
    private func addSubViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        categoriesList.register(TrackerCategoryViewCell.self, forCellReuseIdentifier: "CategoriesList")
        title = "Категория"
        view.addSubview(addCategoryButton)
        view.addSubview(categoriesList)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        showPlaceholder()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesList.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            categoriesList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesList.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -38),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriesList.translatesAutoresizingMaskIntoConstraints = false
    }

    
    private func showPlaceholder() {
        placeholderImage.isHidden = categoryViewModel.listCategories.isEmpty ? false : true
        placeholderLabel.isHidden = categoryViewModel.listCategories.isEmpty ? false : true
    }
    
    @objc private func didTapAddCategoryButton() {
        let controllerToPush = CreateNewCategoryViewController()
        controllerToPush.delegate = categoryViewModel
        self.navigationController?.pushViewController(controllerToPush, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.listCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesList", for: indexPath) as? TrackerCategoryViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = categoryViewModel.listCategories[indexPath.row].categoryName
        
        let cellCount = tableView.numberOfRows(inSection: indexPath.section)
        if cellCount == 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,
                                        .layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.separatorInset.right = tableView.bounds.width
        } else {
            switch indexPath.row {
            case 0:
                cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            case cellCount - 1:
                cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
                cell.separatorInset.right = tableView.bounds.width
            default:
                cell.layer.cornerRadius = 0
            }
        }
        
        cell.accessoryType = categoryViewModel.categoryChosen?.categoryName == cell.textLabel?.text ? .checkmark : .none
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            categoryViewModel.chooseCategory(category: cell.textLabel?.text)
        }
        navigationController?.popViewController(animated: true)
    }
}
