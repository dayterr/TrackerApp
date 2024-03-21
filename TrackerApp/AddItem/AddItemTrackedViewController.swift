//
//  AddItemTrackedViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 16.01.2024.
//

import UIKit

protocol AddItemTrackedViewControllerDelegate: AnyObject {
    func updateTrackersData(newCategory: TrackerCategory, newTracker: Tracker)
}

final class AddItemTrackedViewController: UIViewController {
    
    weak var delegate: AddItemTrackedViewControllerDelegate?
    
    private let options = ["Категория", "Расписание"]
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colours: [UIColor] = (1...18).map { UIColor(named: "Colour\($0)") ?? UIColor.clear }
    private var itemTitle: String?
    private var categoryTitle: String?
    private var indexOfColour: IndexPath?
    private var indexOfEmoji: IndexPath?
    private var scheduleSelected: [DayOfWeek] = []
    private var itemType: TrackerType
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    private lazy var titleField: UITextField = {
        let titleField = UITextField()
        titleField.placeholder = "Введите название трекера"
        titleField.backgroundColor = .ypGrayHex
        titleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: titleField.frame.height))
        titleField.leftViewMode = .always
        titleField.layer.cornerRadius = 16
        titleField.layer.borderWidth = 1.0
        titleField.layer.borderColor = UIColor.ypGrayHex?.cgColor
        titleField.layer.masksToBounds = true
        titleField.addTarget(self, action: #selector(createTrackerName), for: .editingChanged)
        return titleField
    }()
    
    private lazy var limitMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = UIColor(named: "Red")
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(.red, for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(getBackView) , for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = UIColor(named: "Gray")
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(createNewItem), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 3
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(itemType: TrackerType) {
        self.itemType = itemType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        applyConstraints()
        
        updateButtonsTableView()
        hideKeyboard()
    }
    
    private func addSubViews() {
        view.backgroundColor = .white
        buttonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CreateHabbitTableViewCell")
        collectionView.register(EmojisCollectionViewCell.self, forCellWithReuseIdentifier: "EmojisCollectionViewCell")
        collectionView.register(ColoursCollectionViewCell.self, forCellWithReuseIdentifier: "ColoursCollectionViewCell")
        collectionView.register(AddItemTrackedSupplView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(scrollView)
        scrollView.addSubview(titleField)
        scrollView.addSubview(limitMessageLabel)
        scrollView.addSubview(buttonsTableView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(addButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            titleField.heightAnchor.constraint(equalToConstant: 75),
            titleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            limitMessageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            limitMessageLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 4),
            buttonsTableView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 28),
            buttonsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.topAnchor.constraint(equalTo: buttonsTableView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            buttonsStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -17),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60)
        ])
        titleField.translatesAutoresizingMaskIntoConstraints = false
        limitMessageLabel.isHidden = true
        limitMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsTableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateButtonsTableView() {
        switch itemType {
        case .habbit:
            title = "Новая привычка"
            buttonsTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        case .irregularEvent:
            title = "Новое нерегулярное событие"
            buttonsTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    private func turnOnAddButton() {
        if titleField.text != nil, categoryTitle != nil, itemType == .irregularEvent || itemType == .habbit && !scheduleSelected.isEmpty, indexOfColour != nil, indexOfEmoji != nil {
            addButton.isEnabled = true
            addButton.backgroundColor = .ypBlack
        } else {
            addButton.isEnabled = false
            addButton.backgroundColor = UIColor(named: "Gray")
        }
    }
    
    @objc private func createTrackerName() {
        itemTitle = titleField.text
        let nameLength = itemTitle?.count ?? 0
        let maxNameLength = 38
        if nameLength > maxNameLength {
            limitMessageLabel.isHidden = false
        } else {
            limitMessageLabel.isHidden = true
            turnOnAddButton()
        }
    }
    
    @objc private func getBackView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createNewItem() {
        let newItem = Tracker(trackerID: UUID(), name: titleField.text ?? "", colour: colours[indexOfColour?.row ?? 0], emoji: emojis[indexOfEmoji?.row ?? 0], schedule: scheduleSelected, wasAttached: false)
        let newCategory = TrackerCategory(name: categoryTitle ?? "", trackersList: [newItem])
        delegate?.updateTrackersData(newCategory: newCategory, newTracker: newItem)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddItemTrackedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else if section == 1 {
            return colours.count
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojisCollectionViewCell", for: indexPath) as! EmojisCollectionViewCell
            cell.startCellEmoji(indexPath: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColoursCollectionViewCell", for: indexPath) as! ColoursCollectionViewCell
            cell.startFieldColor(indexPath: indexPath)
            cell.isSelected(isSelect: false)
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! AddItemTrackedSupplView
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
        } else {
            view.titleLabel.text = "Цвет"
        }
        return view
    }
}

extension AddItemTrackedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let controllerToPresent = CategoryViewController()
            controllerToPresent.categoryViewModel.delegate = self
            controllerToPresent.categoryViewModel.chooseCategory(category: categoryTitle)
            navigationController?.pushViewController(controllerToPresent, animated: true)
        } else {
            let controllerToPresent = SchedulingViewController()
            controllerToPresent.delegate = self
            controllerToPresent.daysOfWeekChosen = scheduleSelected
            navigationController?.pushViewController(controllerToPresent, animated: true)
        }
    }
}

extension AddItemTrackedViewController {
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}

extension AddItemTrackedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch itemType {
        case .habbit: return 2
        case .irregularEvent: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateHabbitTableViewCell", for: indexPath)
        cell.backgroundColor = .ypGrayHex
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        var choosenAttribute = NSMutableAttributedString()
        var textLabel: String
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row == 0 {
            textLabel = "Категории"
            if let categoryName = categoryTitle {
                textLabel += "\n" + categoryName }
            } else {
                textLabel = "Расписание"
                if !scheduleSelected.isEmpty {
                    textLabel += "\n" + scheduleSelected.map( { $0.abbrName } ).joined(separator: ", ")
                }
            }
            
            choosenAttribute = NSMutableAttributedString(string: textLabel, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
            choosenAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Black") ?? .black, range: NSRange(location: 0, length: textLabel.count))
            
            if textLabel.contains("\n") {
                let position = textLabel.distance(from: textLabel.startIndex, to: textLabel.firstIndex(of: "\n") ?? textLabel.startIndex)
                choosenAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Gray") ?? .gray, range: NSRange(location: position, length: textLabel.count - position))
            }
            
            cell.textLabel?.attributedText = choosenAttribute
            
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
        return cell
    }
}

extension AddItemTrackedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let selectedEmoji = indexOfEmoji {
                let cell = collectionView.cellForItem(at: selectedEmoji) as? EmojisCollectionViewCell
                cell?.isSelected(isSelect: false)
            }
            indexOfEmoji = indexPath
        } else {
            if let selectedColor = indexOfColour {
                let cell = collectionView.cellForItem(at: selectedColor) as? ColoursCollectionViewCell
                cell?.isSelected(isSelect: false)
            }
            indexOfColour = indexPath
        }
        if indexPath.section == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojisCollectionViewCell
            cell?.isSelected(isSelect: true)
            turnOnAddButton()
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColoursCollectionViewCell
            cell?.isSelected(isSelect: true)
            turnOnAddButton()
        }
    }
}

extension AddItemTrackedViewController: CategoryViewModelDelegate {
    func updateCategory(newTitle: String?) {
        categoryTitle = newTitle
        turnOnAddButton()
        buttonsTableView.reloadData()
    }
}


extension AddItemTrackedViewController: SchedulingViewControllerDelegate {
    func updateSchedule(schedule: [DayOfWeek]) {
        scheduleSelected = schedule
        turnOnAddButton()
        
        buttonsTableView.reloadData()
    }
}
