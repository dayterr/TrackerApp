//
//  TrackersCollectionViewCell.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 02.02.2024.
//

import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func trackerDone(id: UUID, indexPath: IndexPath)
    func trackerNotDone(id: UUID, indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var isDone: Bool = false
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    private lazy var field: UIView = {
        let field = UIView()
        field.layer.cornerRadius = 16
        return field
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emoji = UILabel()
        emoji.layer.cornerRadius = 12
        emoji.text = "😪"
        emoji.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emoji.backgroundColor = .clear
        return emoji
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(named: "White")
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        title.numberOfLines = 2
        title.lineBreakMode = .byWordWrapping
        return title
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        return footerView
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var markButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapMarkButton))
        button.backgroundColor = UIColor(named: "White")
        button.layer.cornerRadius = 17
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.addSubview(field)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(footerView)
        footerView.addSubview(amountLabel)
        footerView.addSubview(markButton)
        
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 90),
            field.topAnchor.constraint(equalTo: contentView.topAnchor),
            field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: field.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: field.topAnchor, constant: 44),
            titleLabel.bottomAnchor.constraint(equalTo: field.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: field.trailingAnchor, constant: -12),
            footerView.topAnchor.constraint(equalTo: field.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            amountLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            amountLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24),
            markButton.heightAnchor.constraint(equalToConstant: 34),
            markButton.widthAnchor.constraint(equalToConstant: 34),
            markButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            markButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12)
        ])
        field.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        markButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateCell(tracker: Tracker, trackerWasDone: Bool, days: Int, indexPath: IndexPath) {
        self.trackerID = tracker.ID
        self.indexPath = indexPath
        self.isDone = trackerWasDone
        field.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        amountLabel.text = daysText(days: days)
        let markButtonImage = isDone ? UIImage(named: "DoneButton") : UIImage(named: "PlusButton")
        markButton.setImage(markButtonImage, for: .normal)
        markButton.tintColor = tracker.color
    }
    
    func daysText(days: Int) -> String {
        switch days {
        case 1:
            return "\(days) день"
        case 2...4:
            return "\(days) дня"
        default:
            return "\(days) дней"
        }
    }
    
    @objc private func didTapMarkButton() {
        guard let trackerIdentifier = trackerID, let indexPath = indexPath else { return }
        if isDone {
            delegate?.trackerNotDone(id: trackerIdentifier, indexPath: indexPath)
        } else {
            delegate?.trackerDone(id: trackerIdentifier, indexPath: indexPath)
        }
    }
}
