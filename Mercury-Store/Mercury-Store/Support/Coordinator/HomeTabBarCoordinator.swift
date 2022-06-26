//
//  HomeTabBarCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 02/06/2022.
//

import Foundation
import UIKit

// MARK: - HomeTabBarCoordinator
//
final class HomeTabBarCoordinator : Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var mainTabBar: UITabBarController!
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
        self.mainTabBar = UITabBarController()
    }
    func start() {
        initializeHomeTabBar()
        configureNavController()
    }
}

// MARK: - Private Handlers
//
extension HomeTabBarCoordinator {
    /// Used to make tabs and main coordinators
    ///
    private func initializeHomeTabBar() {
        let tabs: [TabContent] = [
            TabContent(title: "Home",
                       image: UIImage(systemName: "homekit")!,
                       coordinator: HomeCoordinator(navigationController: UINavigationController()), tag: 0),
            TabContent(title: "Category",
                       image: UIImage(systemName: "square.grid.2x2.fill")!,
                       coordinator: CategoryCoordinator(navigationController: UINavigationController()), tag: 1),
            TabContent(title: "Cart",
                       image: UIImage(systemName: "cart.fill")!,
                       coordinator: ShoppingCartCoordinator(navigationController: UINavigationController()), tag: 2),
            TabContent(title: "Profile",
                       image: UIImage(systemName: "person.crop.circle.fill")!,
                       coordinator: MeCoordinator(navigationController: UINavigationController()), tag: 3),
        ]
        
        tabs.forEach { tab in
            let tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tab.tag)
            tab.coordinator.navigationController.tabBarItem = tabBarItem
            tab.coordinator.parentCoordinator = parentCoordinator
            parentCoordinator?.children.append(tab.coordinator)
            tab.coordinator.start()
        }
        mainTabBar.viewControllers = tabs.map(\.coordinator.navigationController)
        
    }
    
    /// Configure navigation bar appearance
    ///
    private func configureNavController() {
        navigationController.pushViewController(mainTabBar, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: -Nested Types
//
extension HomeTabBarCoordinator {
    struct TabContent {
        let title: String
        let image: UIImage
        let coordinator: Coordinator
        let tag: Int
    }
}
