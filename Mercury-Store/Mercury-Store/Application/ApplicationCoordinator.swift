//
//  ApplicationCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 02/06/2022.
//

import Foundation
import UIKit

class ApplicationCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
       goToHomeTabbar()
    }
    
    func goToLaunchScreen(){
        
    }
    
    func goToHomeTabbar(){
        let coordinator = HomeTabBarCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        
        coordinator.start()
    }
}
