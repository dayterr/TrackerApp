//
//  UIScheduleMarshalling.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 22.02.2024.
//

import Foundation

final class UIScheduleMarshalling {

    func int(from schedule: [DayOfWeek]) -> Int16 {
        schedule.map{1 << ($0.dayNumber - 1)}.reduce(0, |)
    }

    func weekDays(from int: Int16) -> [DayOfWeek] {
        var weekDays: [DayOfWeek] = []
        for bitNumber in (0...6) {
            if int >> bitNumber & 1 == 1 {
                weekDays.append(bitNumber != 0 ? DayOfWeek.allCases[bitNumber-1] : DayOfWeek.allCases[6])
            }
        }
        return weekDays
    }
}
