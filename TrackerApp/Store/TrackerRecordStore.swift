//
//  TrackerRecordStore.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 22.02.2024.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func updateTrackerRecords()
}

enum TrackerRecordStoreError: Error {
    case trackerRecordDecodingError
}

final class TrackerRecordStore: NSObject {

    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
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

    var completedTrackers: [TrackerRecord] {
        if let objects = fetchedResultsController.fetchedObjects,
           let completedTrackers = try? objects.map( { try getTrackerRecord(trackerRecordCoreData: $0) } ) {
            return completedTrackers
        } else {
            return []
        }
    }

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

    private func getTrackerRecord(trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        if let identifierTrackerRecord = trackerRecordCoreData.trackerRecordID,
           let dateTrackerRecord = trackerRecordCoreData.date {
            return TrackerRecord(ID: identifierTrackerRecord,
                                 dateRecord: dateTrackerRecord)
        }
        else {
            throw TrackerRecordStoreError.trackerRecordDecodingError
        }
    }

    func addTrackerRecord(trackerRecord: TrackerRecord) throws {
        let recordTrackerCoreData = TrackerRecordCoreData(context: context)
        recordTrackerCoreData.trackerRecordID = trackerRecord.ID
        recordTrackerCoreData.date = trackerRecord.dateRecord
        try context.save()
    }

    func removeTrackerRecord(trackerRecord: TrackerRecord) throws {
        guard let recordTracker = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerRecordID == trackerRecord.ID &&
            Calendar.current.isDate($0.date ?? trackerRecord.dateRecord, inSameDayAs: trackerRecord.dateRecord)
        }) else { return }
        context.delete(recordTracker)
        try context.save()
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateTrackerRecords()
    }
}
