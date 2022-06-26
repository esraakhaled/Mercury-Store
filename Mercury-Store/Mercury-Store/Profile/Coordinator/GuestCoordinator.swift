//
//  GuestCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 10/06/2022.
//

import Foundation
import UIKit


class GuestCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let guestViewModel = GuestViewModel(self)
        let guestVC = GuestProfileViewController(guestViewModel)
        navigationController.pushViewController(guestVC, animated: true)
    }
}

extension GuestCoordinator: GuestNavigationFlow {
    func isLoggedInSuccessfully(_ id: Int) {
        let appC = self.parentCoordinator?.parentCoordinator as! ApplicationCoordinator
        appC.goToHomeTabbar()
        appC.childDidFinish(self)
    }
    
    func goToRegistrationScreen() {
        let viewModel = RegisterViewModel(flow: self)
        let registrationVC = RegisterViewController(viewModel)
        self.navigationController.pushViewController(registrationVC, animated: true)
    }
    
    func goToLoginScreen() {
        let viewModel = LoginViewModel(registerFlow: self)
        let loginVC = LoginViewController(viewModel)
        self.navigationController.pushViewController(loginVC, animated: true)
    }
    

    
    
}
