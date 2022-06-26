//
//  GuestNavigationFlow.swift
//  Mercury-Store
//
//  Created by mac hub on 08/06/2022.
//

import Foundation

protocol GuestNavigationFlow: AnyObject {
    func goToRegistrationScreen()
    func goToLoginScreen()
    func isLoggedInSuccessfully(_ id: Int)
}
