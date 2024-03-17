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

protocol TrackerStoreDelegate: AnyObject {
    func updateCategories()
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = TrackerStore()

    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColourMarshalling()
    private let scheduleMarshalling = UIScheduleMarshalling()
    
    var trackers: [Tracker] {
        if let objects = fetchedResultsController.fetchedObjects,
           let trackers = try? objects.map( { try getTracker(from: $0) } ) {
            return trackers
        } else {
            return []
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.trackerID, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

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
       return Tracker(ID: trackerIdentifier, name: name, color: colorMarshalling.colour(from: color), emoji: emoji, schedule: scheduleMarshalling.weekDays(from: data.schedule), wasAttached: data.wasAttached)
    }

    func saveTracker(tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.ID
        trackerCoreData.name = tracker.name
        trackerCoreData.colour = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleMarshalling.int(from: tracker.schedule)
        trackerCoreData.wasAttached = tracker.wasAttached
        return trackerCoreData
    }
    
    func deleteTracker(trackerIdentifier: UUID?) throws {
        guard let record = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerID == trackerIdentifier } ) else { return }
        context.delete(record)
        try context.save()
    }
        
    func trackerWasAttached(trackerIdentifier: UUID?, wasAttached: Bool) throws {
        guard let record = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerID == trackerIdentifier } ) else { return }
        record.wasAttached = wasAttached
        try context.save()
    }
    
    func getTrackerByIdentifier(trackerIdentifier: UUID?) throws -> Tracker {
        guard let record = fetchedResultsController.fetchedObjects?.first( where: {
            $0.trackerID == trackerIdentifier } ),
              let trackerIdentifier = record.trackerID,
              let name = record.name,
              let color = record.colour,
              let emoji = record.emoji
        else {
            throw TrackerStoreError.decodingTrackerError
        }
        return Tracker(ID: trackerIdentifier, name: name, color: colorMarshalling.colour(from: color), emoji: emoji, schedule: scheduleMarshalling.weekDays(from: record.schedule), wasAttached: record.wasAttached)
    }
}
