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
    
    static let shared = TrackerRecordStore()

    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.dateRecord, ascending: true)]
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
           let dateTrackerRecord = trackerRecordCoreData.dateRecord {
            return TrackerRecord(trackerRecordID: identifierTrackerRecord,
                                 dateRecord: dateTrackerRecord)
        }
        else {
            throw TrackerRecordStoreError.trackerRecordDecodingError
        }
    }

    func addTrackerRecord(trackerRecord: TrackerRecord) throws {
        let recordTrackerCoreData = TrackerRecordCoreData(context: context)
        recordTrackerCoreData.trackerRecordID = trackerRecord.trackerRecordID
        recordTrackerCoreData.dateRecord = trackerRecord.dateRecord
        try context.save()
    }

    func removeTrackerRecord(trackerRecord: TrackerRecord) throws {
        guard let recordTracker = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerRecordID == trackerRecord.trackerRecordID &&
            Calendar.current.isDate($0.dateRecord ?? trackerRecord.dateRecord, inSameDayAs: trackerRecord.dateRecord)
        }) else { return }
        context.delete(recordTracker)
        try context.save()
    }
    
    func removeTrackerRecordById(trackerIdentifier: UUID?) throws {
        guard let record = fetchedResultsController.fetchedObjects?.filter( { $0.trackerRecordID == trackerIdentifier } )
        else { return }
        record.forEach( {context.delete($0) } )
        try context.save()
    }
        
    func comletedTrackerRecordById(trackerIdentifier: UUID) throws  -> Int {
        completedTrackers.filter( { $0.trackerRecordID == trackerIdentifier } ).count
    }
    
    func bestPeriod(trackerRecords: [TrackerRecord], trackers: [Tracker]) throws -> Int {
        var longestStreak = 0
        for tracker in trackers {
            var currentStreak = 0
            var maxStreak = 0
            var lastDate: Date?
            let sortedRecords = trackerRecords.filter { $0.trackerRecordID == tracker.trackerID}.sorted(by: { $0.dateRecord < $1.dateRecord } )
            for record in sortedRecords {
                if let lastDate = lastDate {
                    let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
                    if record.dateRecord >= nextDay {
                        currentStreak += 1
                    } else {
                        currentStreak = 1
                    }
                } else {
                    currentStreak = 1
                }
                lastDate = record.dateRecord
                maxStreak = max(maxStreak, currentStreak)
            }
            longestStreak = max(longestStreak, maxStreak)
        }
        return longestStreak
    }
    
    func averageCompleted() throws -> Int {
        guard let dates = fetchedResultsController.fetchedObjects?.map({
            let components = Calendar.current.dateComponents([.year, .month, .day], from: $0.dateRecord ?? Date())
            return Calendar.current.date(from: components)
        } )
        else { return 0 }
        let countsCompletedInOneDayArray = (dates.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 } ).map( { $0.value } )
        let arraySum = countsCompletedInOneDayArray.reduce(0, +)
        let length = countsCompletedInOneDayArray.count
        let average = length != 0 ? Int(Double(arraySum)/Double(length)) : 0
        return average
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateTrackerRecords()
    }
}
