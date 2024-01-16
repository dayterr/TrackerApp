//
//  MainViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

final class MainViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var addNewTrackerButtonIcon: UIButton = {
        let addNewTrackerButton = UIButton()
        addNewTrackerButton.backgroundColor = .white
        addNewTrackerButton.setImage(UIImage(named: "addNewTrackerButtonIcon"), for: .normal)
        return addNewTrackerButton
    }()
    
    private lazy var titleTrackersLabel: UILabel = {
        let titleTrackersLabel = UILabel()
        titleTrackersLabel.text = "Трекеры"
        titleTrackersLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return titleTrackersLabel
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.delegate = self
        return searchField
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView(image: UIImage(named: "mainBaseImage"))
        return placeholderImage
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return placeholderLabel
    }()
    
    private func setupViews() {
        view.addSubview(titleTrackersLabel)
        view.addSubview(searchField)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTrackerButtonIcon)
        
        NSLayoutConstraint.activate([
            titleTrackersLabel.widthAnchor.constraint(equalToConstant: 254),
            titleTrackersLabel.heightAnchor.constraint(equalToConstant: 41),
            titleTrackersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleTrackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.widthAnchor.constraint(equalToConstant: 343),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: titleTrackersLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
        ])
        titleTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
}



