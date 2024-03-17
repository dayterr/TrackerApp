//
//  StatsViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

final class StatsViewController: UIViewController {

    private let trackerStore = TrackerStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private var bestPeriod = 0
    private var perfectDays = 0
    private var completedTrackers = 0
    private var averageValue = 0

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "Статистика"
        return label
    }()

    private lazy var placeholderImage: UIImageView = {
        let placeholder = UIImageView()
        placeholder.image = UIImage(named: "StatisticPlaceholder")
        return placeholder
    }()

    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Анализировать пока нечего"
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()

    private lazy var bestPeriodView: StatisticView = {
        let statisticView = StatisticView()
        statisticView.parameterValue.text = "0"
        statisticView.parameterTitle.text = "Лучший период"
        return statisticView
    }()

    private lazy var perfectDaysView: StatisticView = {
        let statisticView = StatisticView()
        statisticView.parameterValue.text = "0"
        statisticView.parameterTitle.text = "Идеальные дни"
        return statisticView
    }()

    private lazy var completedTrackersView: StatisticView = {
        let statisticView = StatisticView()
        statisticView.parameterValue.text = "0"
        statisticView.parameterTitle.text = "Трекеров завершено"
        return statisticView
    }()

    private lazy var averageValueView: StatisticView = {
        let statisticView = StatisticView()
        statisticView.parameterValue.text = "0"
        statisticView.parameterTitle.text = "Cреднее значение"
        return statisticView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        applyConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateStatistics()
    }
    
    private func addSubViews() {
        view.backgroundColor = UIColor(named: "White")
        view.addSubview(titleLabel)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderText)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(bestPeriodView)
        stackView.addArrangedSubview(perfectDaysView)
        stackView.addArrangedSubview(completedTrackersView)
        stackView.addArrangedSubview(averageValueView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderText.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 57),
            placeholderText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 396),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func showPlaceholder(placeholderIsHidden: Bool, tableViewIsHidden: Bool) {
        placeholderImage.isHidden = placeholderIsHidden
        placeholderText.isHidden = placeholderIsHidden
        stackView.isHidden = tableViewIsHidden
    }

    private func updateStatistics() {
        bestPeriod = (try? trackerRecordStore.bestPeriod(trackerRecords: trackerRecordStore.completedTrackers, trackers: trackerStore.trackers)) ?? 0
        completedTrackers = trackerRecordStore.completedTrackers.count
        averageValue = (try? trackerRecordStore.averageCompleted()) ?? 0

        if bestPeriod != 0 ||
            perfectDays != 0 ||
            completedTrackers != 0 ||
            averageValue != 0 {

            bestPeriodView.parameterValue.text = String("\(bestPeriod)")
            perfectDaysView.parameterValue.text = String("\(perfectDays)")
            completedTrackersView.parameterValue.text = String("\(completedTrackers)")
            averageValueView.parameterValue.text = String("\(averageValue)")

            showPlaceholder(placeholderIsHidden: true, tableViewIsHidden: false)
        } else {
            showPlaceholder(placeholderIsHidden: false, tableViewIsHidden: true)
        }
    }
}
