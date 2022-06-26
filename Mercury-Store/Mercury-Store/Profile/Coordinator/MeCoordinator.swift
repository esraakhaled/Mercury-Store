//
//  MeCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 10/06/2022.
//

import Foundation
import UIKit

class MeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let guestCoordinator = GuestCoordinator(navigationController: navigationController)
        self.children.append(guestCoordinator)
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        self.children.append(profileCoordinator)
        if getUserFromUserDefaults() {
            profileCoordinator.parentCoordinator = self
            profileCoordinator.start()
        } else {
            guestCoordinator.parentCoordinator = self
            guestCoordinator.start()
        }
        
    }
}

extension MeCoordinator {
    private func getUserFromUserDefaults() -> Bool {
        do {
            let user = try UserDefaults.standard.getObject(forKey: "user", castTo: User.self)
            print(user)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
