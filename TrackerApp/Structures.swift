//
//  Structures.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

enum DayOfWeek: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Cреда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Cуббота"
    case sunday = "Воскресенье"
    
    var abbrName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Cр"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var dayNumber: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}

enum TrackerType {
    case habbit
    case irregularEvent
}

struct Tracker {
    let ID: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]
}

struct TrackerCategory {
    let name: String
    let trackersList: [Tracker]
}

struct TrackerRecord {
    let ID: UUID
    let dateRecord: Date
}
