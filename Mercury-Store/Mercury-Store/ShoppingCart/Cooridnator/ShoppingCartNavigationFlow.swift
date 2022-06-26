//
//  ShoppingCartNavigationFlow.swift
//  Mercury-Store
//
//  Created by mac hub on 16/06/2022.
//

import Foundation

protocol ShoppingCartNavigationFlow: AnyObject {
    func goToAddressesScreen()
    func goToGuestTab()
    func goToPaymentScreen(selectedAddress: CustomerAddress)
    func popToRoot()
    func goToEditAddressScreen(with selectedAddress: CustomerAddress)
}
