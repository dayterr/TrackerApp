//
//  TrackerStore.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 22.02.2024.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingTrackerError
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {

    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColourMarshalling()
    private let scheduleMarshalling = UIScheduleMarshalling()

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }

   func getTracker(from data: NSSet.Element) throws -> Tracker {
        guard
            let data = data as? TrackerCoreData,
            let trackerIdentifier = data.trackerID,
            let name = data.name,
            let color = data.colour,
            let emoji = data.emoji
        else {
            throw TrackerStoreError.decodingTrackerError
        }
       return Tracker(ID: trackerIdentifier, name: name, color: colorMarshalling.colour(from: color), emoji: emoji, schedule: scheduleMarshalling.weekDays(from: data.schedule))
    }

    func saveTracker(tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.ID
        trackerCoreData.name = tracker.name
        trackerCoreData.colour = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleMarshalling.int(from: tracker.schedule)
        return trackerCoreData
    }
}
