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
    private var trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()
    
    private lazy var addNewTrackerButtonIcon: UIButton = {
        let addNewTrackerButton = UIButton()
        addNewTrackerButton.backgroundColor = .white
        addNewTrackerButton.setImage(UIImage(named: "addNewTrackerButtonIcon"), for: .normal)
        addNewTrackerButton.addTarget(self, action: #selector(tapAddNewTrackerButton), for: .touchUpInside)
        return addNewTrackerButton
    }()
    
    private lazy var titleTrackersLabel: UILabel = {
        let titleTrackersLabel = UILabel()
        titleTrackersLabel.text = "Трекеры"
        titleTrackersLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return titleTrackersLabel
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
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
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return placeholderLabel
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor(named: "whiteDatePicker")
        datePicker.locale = Locale(identifier: "ru")
        datePicker.layer.cornerRadius = 8
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
    
    private func setupViews() {
        view.addSubview(titleTrackersLabel)
        view.addSubview(searchField)
        view.addSubview(trackersCollection)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTrackerButtonIcon)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
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
        ])
        titleTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        trackersCollection.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        view.backgroundColor = .white
        setupViews()
        
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
        trackerRecordStore.delegate = self
        completedTrackers = trackerRecordStore.completedTrackers
        
        visibleCategories = categories
        updateVisibleCategories()
    }
    
    private func showPlaceholder(message: String, image: UIImage, isHidden: Bool) {
        placeholderLabel.text = message
        placeholderImage.image = image
        placeholderLabel.isHidden = isHidden
        placeholderImage.isHidden = isHidden
    }
    
    @objc private func tapAddNewTrackerButton() {
        let createController = SelectTypeViewController()
        createController.delegate = self
        let navigationController = UINavigationController(rootViewController: createController)
        present(navigationController, animated: true)
    }
    
    @objc private func updateVisibleCategories() {
        let calendar = Calendar.current
        let dateFilter = calendar.component(.weekday, from: datePicker.date)
        let nameFilter = (searchField.text ?? "").lowercased()
        
       visibleCategories = categories.compactMap { category in
           let trackers = category.trackersList.filter { tracker in
               let name = nameFilter.isEmpty || tracker.name.lowercased().contains(nameFilter)
               let date = tracker.schedule.contains { day in
                   day.dayNumber == dateFilter
               } == true || tracker.schedule.isEmpty
               return name && date
           }
           if trackers.isEmpty {
               return nil
           }
           return TrackerCategory(name: category.name, trackersList: trackers)
       }
        
        if categories.isEmpty {
            showPlaceholder(message: "Что будем отслеживать?", image: UIImage(named: "mainBaseImage") ?? UIImage(), isHidden: false)
        } else
        if visibleCategories.isEmpty {
            showPlaceholder(message: "Ничего не найдено", image: UIImage(named: "notFoundImage") ?? UIImage(), isHidden: false)
        } else {
            showPlaceholder(message: "", image: UIImage(), isHidden: true)
        }
        trackersCollection.reloadData()
        dismiss(animated: true)
    }
    
    private func isTrackerRecorded(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            trackerRecord.ID == id && Calendar.current.isDate(trackerRecord.dateRecord, inSameDayAs: datePicker.date)
        }
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
        try? trackerRecordStore.removeTrackerRecord(trackerRecord: trackerRecord)
    }
    
    func trackerNotDone(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(ID: id, dateRecord: datePicker.date)
        try? trackerRecordStore.removeTrackerRecord(trackerRecord: trackerRecord)
        trackersCollection.reloadItems(at: [indexPath])
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
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    
    func updateTrackerRecords() {
        completedTrackers = trackerRecordStore.completedTrackers
    }
}
