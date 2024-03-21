//
//  Colors.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 19.03.2024.
//

import UIKit

final class Colors {
    var collectionViewBackgroundColor: UIColor = .systemBackground

    var navigationBarTintColor: UIColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypWhite! : UIColor.ypBlack!
    }
}

extension UIColor {
    static let ypBlack = UIColor(named: "Black")
    static let ypWhite = UIColor(named: "White")
    static let ypGrayHex = UIColor(named: "GrayHex")
}
