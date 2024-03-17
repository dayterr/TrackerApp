//
//  CreateNewCategoryViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 07.03.2024.
//

import UIKit

protocol CreateNewCategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategoryTitle: String)
}

//фиксить
final class CreateNewCategoryViewController: UIViewController {
    
    weak var delegate: CreateNewCategoryViewControllerDelegate?
    private var categoryTitle: String?
    
    private lazy var nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категори"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(named: "GrayHex")
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "GrayHex")?.cgColor
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(changeCategoryName), for: .editingChanged)
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = UIColor(named: "Gray")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
 
// MARK: - ControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        applyConstraints()
        
        nameField.delegate = self
        hideKeyboard()
    }
   
// MARK: - SetupViews
    
    private func addSubViews() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Новая категория"
        view.addSubview(nameField)
        view.addSubview(doneButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
// MARK: - PrivateFunctions
    
    private func activateReadyButton() {
        if categoryTitle != nil {
            doneButton.isEnabled = true
            doneButton.backgroundColor = UIColor(named: "Black")
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = UIColor(named: "Gray")
        }
    }
    
    @objc private func changeCategoryName() {
        categoryTitle = nameField.text
        activateReadyButton()
    }
    
    @objc private func didTapDoneButton() {
        guard let categoryTitle else { return }
        delegate?.updateNewCategory(newCategoryTitle: categoryTitle)
        navigationController?.popViewController(animated: true)
    }
}

extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension CreateNewCategoryViewController {
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}
