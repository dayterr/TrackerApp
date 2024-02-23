//
//  EmojisCollectionViewCell.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 23.01.2024.
//

import UIKit

final class EmojisCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

