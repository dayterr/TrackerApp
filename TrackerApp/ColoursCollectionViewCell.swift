//
//  ColoursCollectionViewCell.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 23.01.2024.
//

import UIKit

final class ColoursCollectionViewCell: UICollectionViewCell {
    let view: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(view)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 12),
            view.heightAnchor.constraint(equalToConstant: contentView.bounds.height - 12),
            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not bean implemented")
    }
}
