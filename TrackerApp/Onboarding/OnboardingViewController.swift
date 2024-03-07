//
//  OnboardingViewController.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 08.03.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pages: [UIViewController] = {
        var firstPage = OnboardingPageViewController(imageView: UIImage(named: "OnboardingBlue") ?? UIImage(), text: "Отслеживайте только то, что хотите")
        var secondPage = OnboardingPageViewController(imageView: UIImage(named: "OnboardingRed") ?? UIImage(), text: "Даже если это не литры воды и йога")
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Black")
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(pageControl)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }

}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = (viewControllerIndex + pages.count - 1) % pages.count
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = (viewControllerIndex + 1) % pages.count
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
