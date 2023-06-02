//
//  ViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: HomeCollectionViewController(),
                title: NSLocalizedString("Home", comment: ""),
                image: UIImage(systemName: "house.fill"),
                badgeValue: nil
            ),
            generateVC(
                viewController: SavedRecipesCollectionViewController(),
                title: NSLocalizedString("Saved", comment: ""),
                image: UIImage(systemName: "square.and.arrow.down"),
                badgeValue: nil
            ),
            generateVC(
                viewController: SearchCollectionViewController(),
                title: NSLocalizedString("Search", comment: ""),
                image: UIImage(systemName: "magnifyingglass"),
                badgeValue: nil
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?, badgeValue: String?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.badgeValue = badgeValue
        return navigationController
    }
    
    private func setTabBarAppearance() {
        tabBar.backgroundColor = .systemBackground
    }


}

