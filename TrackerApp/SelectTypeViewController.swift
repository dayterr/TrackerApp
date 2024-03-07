//
//  SelectTypeViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

final class SelectTypeViewController: UIViewController {
    
    weak var delegate: AddItemTrackedViewControllerDelegate?
    
    private lazy var createHabbitButton: UIButton = {
        let habbitButton = UIButton()
        habbitButton.backgroundColor = UIColor(named: "Black")
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.layer.cornerRadius = 16
        habbitButton.addTarget(self, action: #selector(tapCreateHabbitButton), for: .touchUpInside)
        return habbitButton
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.backgroundColor = UIColor(named: "Black")
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.addTarget(self, action: #selector(tapCreateIrregularEventButton), for: .touchUpInside)
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "White")
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Создание трекера"
        self.view.addSubview(createHabbitButton)
        self.view.addSubview(createIrregularEventButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabbitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            createHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            createIrregularEventButton.topAnchor.constraint(equalTo: createHabbitButton.bottomAnchor, constant: 16),
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        createHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        createIrregularEventButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func tapCreateHabbitButton() {
        let addItemTrackedViewController = AddItemTrackedViewController(itemType: .habbit)
        addItemTrackedViewController.delegate = self
        navigationController?.pushViewController(addItemTrackedViewController, animated: true)
    }
    
    @objc private func tapCreateIrregularEventButton() {
        let addItemTrackedViewController = AddItemTrackedViewController(itemType: .irregularEvent)
        addItemTrackedViewController.delegate = self
        navigationController?.pushViewController(addItemTrackedViewController, animated: true)
    }
    
}

extension SelectTypeViewController: AddItemTrackedViewControllerDelegate {
    func updateTrackersData(newCategory: TrackerCategory, newTracker: Tracker) {
        delegate?.updateTrackersData(newCategory: newCategory, newTracker: newTracker)
    }
}
