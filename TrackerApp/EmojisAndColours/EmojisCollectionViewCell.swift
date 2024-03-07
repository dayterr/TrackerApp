//
//  EmojisCollectionViewCell.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 23.01.2024.
//

import UIKit

final class EmojisCollectionViewCell: UICollectionViewCell {
    
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private var fieldView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(fieldView)
        contentView.addSubview(titleLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fieldView.heightAnchor.constraint(equalToConstant: 52),
            fieldView.widthAnchor.constraint(equalToConstant: 52),
        ])
        fieldView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSelected(isSelect: Bool) {
        let colour = isSelect ? UIColor(named: "LightGrey") : .clear
        fieldView.backgroundColor = colour
    }
    
    func startCellEmoji(indexPath: IndexPath) {
        titleLabel.text = emojis[indexPath.row]
    }
}

