//
//  TabBarController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private enum TabBarItem: Int {
        case trackers
        case stats
        
        var itemTitle: String {
            switch self {
            case .trackers:
                return "Трекеры"
            case . stats:
                return "Cтатистика"
            }
        }
        
        var iconName: String {
            switch self {
            case .trackers:
                return "trackersBarIcon"
            case .stats:
                return "statsBarIcon"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
    }
    
    private func wrappedNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.trackers, .stats]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .trackers:
                let trackersViewController = MainViewController()
                return self.wrappedNavigationController(with: trackersViewController, title: $0.itemTitle)
                
            case .stats:
                let statsViewController = StatsViewController()
                return self.wrappedNavigationController(with: statsViewController, title: $0.itemTitle)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].itemTitle
            $1.tabBarItem.image = UIImage(named: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
}
