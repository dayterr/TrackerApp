//
//  SchedulingViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 02.02.2024.
//

import UIKit

protocol SchedulingViewControllerDelegate: AnyObject {
    func updateSchedule(schedule: [DayOfWeek])
}

final class SchedulingViewController: UIViewController {
    
    weak var delegate: SchedulingViewControllerDelegate?
    
    private let daysOfWeek: [String] = DayOfWeek.allCases.map { $0.rawValue }
    
    var daysOfWeekChosen: [DayOfWeek] = []
    
    private lazy var scheduleTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return titleLabel
    }()
    
    private lazy var daysOfWeekTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var completedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = UIColor(named: "Black")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysOfWeekTableView.register(UITableViewCell.self, forCellReuseIdentifier: "weekDayCell")
        
        addSubViews()
        applyConstraints()
        
        view.backgroundColor = .white
    }
    
    private func addSubViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(scheduleTitleLabel)
        view.addSubview(daysOfWeekTableView)
        view.addSubview(completedButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scheduleTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            scheduleTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            daysOfWeekTableView.topAnchor.constraint(equalTo: scheduleTitleLabel.bottomAnchor, constant: 30),
            daysOfWeekTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysOfWeekTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            daysOfWeekTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * daysOfWeek.count)),
            completedButton.heightAnchor.constraint(equalToConstant: 60),
            completedButton.widthAnchor.constraint(equalToConstant: 335),
            completedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        scheduleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        daysOfWeekTableView.translatesAutoresizingMaskIntoConstraints = false
        completedButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func switcher(for indexPath: IndexPath) -> UISwitch {
        let switcher = UISwitch(frame: .zero)
        let weekDay = DayOfWeek.allCases[indexPath.row]
        switcher.setOn(daysOfWeekChosen.contains(weekDay), animated: true)
        switcher.onTintColor = UIColor(named: "Blue")
        switcher.tag = indexPath.row
        switcher.addTarget(self, action: #selector(switcherChanged), for: .valueChanged)
        return switcher
    }
    
    @objc private func didTapCompleteButton() {
        delegate?.updateSchedule(schedule: daysOfWeekChosen)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switcherChanged(_ sender: UISwitch) {
        let index = sender.tag
        let weekDay = DayOfWeek.allCases[index]
        if sender.isOn {
            daysOfWeekChosen.append(weekDay)
            daysOfWeekChosen = DayOfWeek.allCases.filter { daysOfWeekChosen.contains($0) }
        } else {
            daysOfWeekChosen = daysOfWeekChosen.filter { $0 != weekDay }
        }
    }
}

extension SchedulingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DayOfWeek.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = daysOfWeekTableView.dequeueReusableCell(withIdentifier: "weekDayCell", for: indexPath)
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.backgroundColor = UIColor(named: "GrayHex")
        cell.accessoryView = switcher(for: indexPath)
        return cell
    }
}
