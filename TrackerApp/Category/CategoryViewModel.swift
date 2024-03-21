//
//  CategoryViewModel.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 07.03.2024.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func updateCategory(newTitle: String?)
}

final class CategoryViewModel {
    weak var delegate: CategoryViewModelDelegate?
        
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    @Observable
    private(set) var listCategories: [CategoryModel] = []
    
    @Observable
    private(set) var categoryChosen: CategoryModel?
    
    init() {
        listCategories = trackerCategoryStore.trackerCategories.map { CategoryModel(categoryName: $0.name) }
    }
    
    func chooseCategory(category: String?) {
        guard let category else { return }
        categoryChosen = CategoryModel(categoryName: category)
        delegate?.updateCategory(newTitle: category)
    }
}

extension CategoryViewModel: CreateNewCategoryViewControllerDelegate {
    func updateNewCategory(newCategoryTitle: String) {
        let newCategory = CategoryModel(categoryName: newCategoryTitle)
        if !listCategories.contains(where: { $0.categoryName == newCategoryTitle } ) {
            listCategories.insert(newCategory, at: 0)
            try? trackerCategoryStore.saveNewTrackerCategory(categoryTitle: newCategoryTitle)
        }
        categoryChosen = newCategory
    }
}
