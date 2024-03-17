//
//  TrackerCategoryViewCell.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 08.03.2024.
//

import UIKit

final class TrackerCategoryViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "GrayHex")
        textLabel?.textColor = UIColor(named: "Black")
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        layer.cornerRadius = 16
        separatorInset.right = 16
        clipsToBounds = true
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
