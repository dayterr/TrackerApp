//
//  TrackerCategoryStore.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 22.02.2024.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingCategoryError
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func updateCategories()
}

final class TrackerCategoryStore: NSObject {

    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private var trackerStore = TrackerStore()

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()

    var trackerCategories: [TrackerCategory] {
        if let objects = fetchedResultsController.fetchedObjects,
           let trackerCategories = try? objects.map( { try getTrackerCategory(trackerCategoryCoreData: $0) } ) {
            return trackerCategories
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

    func getTrackerCategory(trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        if let name = trackerCategoryCoreData.name {
            let trackersList = try trackerCategoryCoreData.trackers?.map( { try trackerStore.getTracker(from: $0) } ) ?? []
            return TrackerCategory(name: name, trackersList: trackersList.sorted(by: { $0.name < $1.name } ))
        } else {
            throw TrackerCategoryStoreError.decodingCategoryError
        }
    }

    func saveTrackerCategory(newCategory: TrackerCategory) throws {
        guard let newTracker = newCategory.trackersList.first else { return }
        let tracker = try trackerStore.saveTracker(tracker: newTracker)

        if let category = fetchedResultsController.fetchedObjects?.first(where: { $0.name == newCategory.name }) {
            category.addToTrackers(tracker)
        } else {
            let category = TrackerCategoryCoreData(context: context)
            category.name = newCategory.name
            category.trackers = NSSet(array: [tracker])
        }
        try context.save()
    }
    
    func saveNewTrackerCategory(categoryTitle: String) throws {
        let category = TrackerCategoryCoreData(context: context)
        category.name = categoryTitle
        try context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateCategories()
    }
}
