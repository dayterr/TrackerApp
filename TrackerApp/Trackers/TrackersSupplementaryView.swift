//
//  TrackersSupplementaryView.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 02.02.2024.
//

import UIKit

final class TrackersSupplementaryView: UICollectionReusableView {
    
    lazy var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.textColor = UIColor(named: "Black")
        addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func launchEmojiTitle() {
        headerLabel.text = "Emoji"
    }

    func launchColorTitle() {
        headerLabel.text = "Цвет"
    }
}
