//
//  LaunchScreenCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 16/06/2022.
//

import Foundation
import UIKit

class LaunchScreenCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToLaunchScreen()
    }
    
    func goToLaunchScreen() {
        let launchVC = LaunchViewController(self)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(launchVC, animated: true)
    }
}

extension LaunchScreenCoordinator: LaunchScreenNavigationFlow {
    func goToHomeTabbar() {
        let appCoordinator = parentCoordinator as! ApplicationCoordinator
        appCoordinator.goToHomeTabbar()
        parentCoordinator?.childDidFinish(self)
    }
    
    func goToOnBoardingScreen() {
        let pagesViewController = ViewController(self)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(pagesViewController, animated: true)
    }
}
