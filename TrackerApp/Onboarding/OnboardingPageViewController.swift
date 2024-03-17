//
//  OnboardingPageViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 08.03.2024.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    private lazy var imageView = UIImageView()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(named: "Black")
        textLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    private lazy var closeOnboardingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(UIColor(named: "White"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCloseOnboardingButton), for: .touchUpInside)
        return button
    }()
    
    init(imageView: UIImage, text: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.imageView = UIImageView(image: imageView)
        self.textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(textLabel)
        view.addSubview(closeOnboardingButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageView.bounds.height / imageView.bounds.width),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            closeOnboardingButton.heightAnchor.constraint(equalToConstant: 60),
            closeOnboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeOnboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeOnboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.closeOnboardingButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapCloseOnboardingButton() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Unable to create window")
        }
        window.rootViewController = TabBarController()
    }
}
