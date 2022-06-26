//
//  GuestViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 08/06/2022.
//

import Foundation

protocol GuestViewModelType {
    func registerButtonTapped()
    func loginButtonTapped()
}

final class GuestViewModel: GuestViewModelType {

    private weak var guestFlow: GuestNavigationFlow?
    
    init(_ guestFlow: GuestNavigationFlow) {
        self.guestFlow = guestFlow
    }
    
    func registerButtonTapped() {
        guestFlow?.goToRegistrationScreen()
    }
    
    func loginButtonTapped() {
        guestFlow?.goToLoginScreen()
    }
    
}
