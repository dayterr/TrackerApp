//
//  MainViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

final class TrackersViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: AddItemTrackedViewControllerDelegate?
    
    var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var attachedTrackers: [Tracker] = []
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private var trackerRecordStore = TrackerRecordStore.shared
    private var trackerStore = TrackerStore.shared
    private var analyticsService = AnalyticsService.shared
    private var selectedFilter = Filter.allTrackers
    
    private lazy var addNewTrackerButtonIcon: UIBarButtonItem = {
        let addNewTrackerButton = UIBarButtonItem()
        addNewTrackerButton.tintColor = .ypBlack
        addNewTrackerButton.image = UIImage(named: "addNewTrackerButtonIcon")
        addNewTrackerButton.action = #selector(tapAddNewTrackerButton)
        return addNewTrackerButton
    }()
    
    private lazy var titleTrackersLabel: UILabel = {
        let titleTrackersLabel = UILabel()
        titleTrackersLabel.text = NSLocalizedString("trackersTitle", comment: "Text displayed on empty state")
        titleTrackersLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return titleTrackersLabel
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = NSLocalizedString("searchPlaceholder", comment: "Text displayed on empty state")
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(updateVisibleCategories), for: .allEditingEvents)
        return searchField
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView(image: UIImage(named: "mainBaseImage"))
        return placeholderImage
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("mainPlaceholderTextOne", comment: "Text displayed on empty state")
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return placeholderLabel
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru")
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = UIColor(named: "datePickerTextColour")
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.calendar.firstWeekday = 2
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(updateVisibleCategories), for: .valueChanged)
        return datePicker
    }()
    
    lazy var trackersCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let trackersCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        trackersCollection.backgroundColor = .clear
        return trackersCollection
    }()
    
    private var currentDate: Date {
        let currentDate = datePicker.date
        return currentDate
    }
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Blue")
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitle(NSLocalizedString("filterButton", comment: "Text displayed on empty state"), for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapFilterButton), for: .touchUpInside)
        return button
    }()
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(titleTrackersLabel)
        view.addSubview(searchField)
        view.addSubview(trackersCollection)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(filterButton)
                
        addNewTrackerButtonIcon.target = self
        
        navigationItem.leftBarButtonItem = addNewTrackerButtonIcon
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem?.width = 120

        trackersCollection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackersCollectionViewCell")
        trackersCollection.register(TrackersSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackersSupplementaryView")
        
        NSLayoutConstraint.activate([
            titleTrackersLabel.widthAnchor.constraint(equalToConstant: 254),
            titleTrackersLabel.heightAnchor.constraint(equalToConstant: 41),
            titleTrackersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleTrackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.widthAnchor.constraint(equalToConstant: 343),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: titleTrackersLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 18),
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
        titleTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        trackersCollection.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        trackersCollection.dataSource = self
        trackersCollection.delegate = self
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        
        updateVisibleCategories()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        analyticsService.reportEvent(event: "open", params: ["screen":"Main"])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        analyticsService.reportEvent(event: "close", params: ["screen":"Main"])
    }
    
    private func showPlaceholder(message: String, image: UIImage, isHidden: Bool) {
        placeholderLabel.text = message
        placeholderImage.image = image
        placeholderLabel.isHidden = isHidden
        placeholderImage.isHidden = isHidden
    }
    
    func isTrackerRecorded(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            trackerRecord.ID == id && Calendar.current.isDate(trackerRecord.dateRecord, inSameDayAs: datePicker.date)
        }
    }
    
    @objc private func tapAddNewTrackerButton() {
        let createController = SelectTypeViewController()
        createController.delegate = self
        let navigationController = UINavigationController(rootViewController: createController)
        analyticsService.reportEvent(event: "click", params: ["screen":"Main", "item":"add_track"])
        present(navigationController, animated: true)
    }
    
    @objc private func tapFilterButton() {
       let filterViewController = FilterViewController()
       filterViewController.delegate = self
       filterViewController.selectedFilter = selectedFilter
       let navigationController = UINavigationController(rootViewController: filterViewController)
       analyticsService.reportEvent(event: "click", params: ["screen":"Main", "item":"filter"])
       present(navigationController, animated: true)
   }
    
    @objc private func updateVisibleCategories() {
        categories = trackerCategoryStore.trackerCategories
        completedTrackers = trackerRecordStore.completedTrackers
        attachedTrackers = categories.flatMap( { $0.trackersList.filter( { $0.wasAttached } ) } )
        
        if !attachedTrackers.isEmpty {
            categories = categories.compactMap { category in
                let trackersList = category.trackersList.filter { !$0.wasAttached }
                if trackersList.isEmpty {
                    return nil
                }
                return TrackerCategory(name: category.name, trackersList: trackersList)
            }
            categories.insert(TrackerCategory(name: "Закреплённые", trackersList: attachedTrackers), at: 0)
        }
        
        let calendar = Calendar.current
        let dateFilter = calendar.component(.weekday, from: datePicker.date)
        let nameFilter = (searchField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackersList.filter { tracker in
                let name = nameFilter.isEmpty || tracker.name.lowercased().contains(nameFilter)
                let date = tracker.schedule.contains { day in
                    day.dayNumber == dateFilter
                } == true || tracker.schedule.isEmpty
                
                switch selectedFilter {
                case .allTrackers, .trackersForToday:
                    return name && date
                case .completedTrackers:
                    return name && date && isTrackerRecorded(id: tracker.ID)
                case .incompletedTrackers:
                    return name && date && !isTrackerRecorded(id: tracker.ID)
                }
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, trackersList: trackers)
        }
        if categories.isEmpty {
            showPlaceholder(message: NSLocalizedString("mainPlaceholderTextOne", comment: "Text displayed on empty state"), image: UIImage(named: "mainBaseImage") ?? UIImage(), isHidden: false)
        } else
        if visibleCategories.isEmpty {
            showPlaceholder(message: NSLocalizedString("mainPlaceholderTextTwo", comment: "Text displayed on empty state"), image: UIImage(named: "notFoundImage") ?? UIImage(), isHidden: false)
        } else {
            showPlaceholder(message: "", image: UIImage(), isHidden: true)
        }
        trackersCollection.reloadData()
        dismiss(animated: true)
    }
}

extension TrackersViewController: AddItemTrackedViewControllerDelegate {
    
    func updateTrackersData(newCategory: TrackerCategory, newTracker: Tracker) {

        try? trackerCategoryStore.saveTrackerCategory(newCategory: newCategory)
        updateVisibleCategories()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = trackersCollection.dequeueReusableCell(withReuseIdentifier: "TrackersCollectionViewCell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackersList[indexPath.row]
        cell.delegate = self
        let completedDays = completedTrackers.filter {
            $0.ID == tracker.ID
        }.count
        let trackerIsDone = isTrackerRecorded(id: tracker.ID)
        cell.prepareForReuse()
        cell.updateCell(tracker: tracker, trackerDone: trackerIsDone, days: completedDays, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "TrackersSupplementaryView",
            for: indexPath) as? TrackersSupplementaryView
        headerView?.headerLabel.text = visibleCategories[indexPath.section].name
        return headerView ?? TrackersSupplementaryView()
    }
}

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func trackerDone(id: UUID, indexPath: IndexPath) {
        if datePicker.date > Date() {
            return
        }
        let trackerRecord = TrackerRecord(ID: id, dateRecord: datePicker.date)
        try? trackerRecordStore.addTrackerRecord(trackerRecord: trackerRecord)
        trackersCollection.reloadItems(at: [indexPath])
    }
    
    func trackerNotDone(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(ID: id, dateRecord: datePicker.date)
        try? trackerRecordStore.removeTrackerRecord(trackerRecord: trackerRecord)
        trackersCollection.reloadItems(at: [indexPath])
    }
    
    func openContextMenu(id: UUID?, indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let attachedTracker = categories.contains(where: { category in
            category.trackersList.contains(where: { $0.ID == id && $0.wasAttached } )
        })
        
        let attachTracker = UIAction(title: attachedTracker ? NSLocalizedString("unattach", comment: "Text displayed on empty state") : NSLocalizedString("attach", comment: "Text displayed on empty state")) { [weak self] _ in
            try? self?.trackerStore.trackerWasAttached(trackerIdentifier: id, wasAttached: !attachedTracker)
            self?.updateVisibleCategories()
        }
        
        let editTracker = UIAction(title: NSLocalizedString("edit", comment: "Text displayed on empty state")) { [weak self] _ in
            self?.analyticsService.reportEvent(event: "click", params: ["screen":"Main", "item":"edit"])
            let categoryTitle = try? self?.trackerCategoryStore.categoryContainsTracker(trackerIdentifier: id)
            let editedTracker = try? self?.trackerStore.getTrackerByIdentifier(trackerIdentifier: id)
            
            guard let editedTracker,
                  let categoryTitle else { return }
            
            let editViewController = editedTracker.schedule.isEmpty ? EditTrackerViewController(trackerType: .irregularEvent, categoryName: categoryTitle, tracker: editedTracker) : EditTrackerViewController(trackerType: .habbit, categoryName: categoryTitle, tracker: editedTracker)
            editViewController.numberOfTrackerExecutions = (try? self?.trackerRecordStore.comletedTrackerRecordById(trackerIdentifier: editedTracker.ID)) ?? 0
            editViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: editViewController)
            self?.present(navigationController, animated: true)
        }
        
        let deleteTracker = UIAction(title: NSLocalizedString("delete", comment: "Text displayed on empty state"), attributes: .destructive) { [weak self] _ in
            self?.analyticsService.reportEvent(event: "click", params: ["screen":"Main", "item":"delete"])
            let alert = UIAlertController(
                title: "",
                message: NSLocalizedString("deleteWarning", comment: "Text displayed on empty state"),
                preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: "Text displayed on empty state"),
                                          style: .destructive) { [self] _ in
                try? self?.trackerStore.deleteTracker(trackerIdentifier: id)
                try? self?.trackerRecordStore.removeTrackerRecordById(trackerIdentifier: id)
                
                let newVisibleCategories = self?.visibleCategories.map { category in
                    let trackers = category.trackersList.filter { $0.ID != id }
                    return TrackerCategory(name: category.name, trackersList: trackers)
                }
                
                self?.visibleCategories = newVisibleCategories.map { category in
                    category.filter { !$0.trackersList.isEmpty }
                } ?? []
                
                self?.trackersCollection.performBatchUpdates ( {
                    if self?.trackersCollection.numberOfItems(inSection: indexPath.section) == 1 {
                        self?.trackersCollection.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet)
                    } else {
                        self?.trackersCollection.deleteItems(at: [indexPath])
                    }
                }) { _ in
                    self?.trackersCollection.reloadItems(at: (self?.trackersCollection.indexPathsForVisibleItems)!)
                    self?.updateVisibleCategories()
                }
            })
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Text displayed on empty state"),
                                          style: .cancel))
            self?.present(alert, animated: true)
            return
        }
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [attachTracker, editTracker, deleteTracker])
        })
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2 - 5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(
            width: collectionView.frame.width,
            height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackersViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateVisibleCategories()
        return textField.resignFirstResponder()
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    
    func updateCategories() {
        categories = trackerCategoryStore.trackerCategories
        print("categories")
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    
    func updateTrackerRecords() {
        completedTrackers = trackerRecordStore.completedTrackers
    }
}

extension TrackersViewController: FilterViewControllerDelegate {
    func selectedFilters(filter: Filter) {
        selectedFilter = filter
        if filter == .trackersForToday {
            datePicker.date = Date()
        }
        updateVisibleCategories()
    }
}
