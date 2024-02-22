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
    
    var titleLabel: UILabel = {
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(fieldView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fieldView.heightAnchor.constraint(equalToConstant: 52),
            fieldView.widthAnchor.constraint(equalToConstant: 52),
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSelected(isSelect: Bool) {
        if let colour = isSelect ? UIColor(named: "LightGrey") : .clear {
            fieldView.backgroundColor = colour
        } else {
            fieldView.backgroundColor = UIColor.lightGray
        }
    }
    
    func startCellEmoji(indexPath: IndexPath) {
        titleLabel.text = emojis[indexPath.row]
    }
}

