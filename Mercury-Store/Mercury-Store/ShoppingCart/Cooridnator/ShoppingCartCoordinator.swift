//
//  ShoppingCartCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 02/06/2022.
//

import UIKit

class ShoppingCartCoordinator: Coordinator{
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        let cartViewModel = CartViewModel(shoppingCartNavigationFlow: self)
        
        let cartVC = ShoppingCartViewController(with: cartViewModel)
        
        navigationController.pushViewController(cartVC, animated: true)
    }
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ShoppingCartCoordinator: ShoppingCartNavigationFlow {
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    
    func goToAddressesScreen() {
        let addressViewModel: AddressViewModelType = AddressViewModel(addressNavigationFlow: self, cartNavigationFlow: self)
        let addressesCheckVC = AddressesCheckViewController(with: addressViewModel)
        navigationController.pushViewController(addressesCheckVC, animated: true)
    }
    
    func goToGuestTab() {
        self.navigationController.tabBarController?.selectedIndex = 3
    }
    
    func goToPaymentScreen(selectedAddress: CustomerAddress) {
        let viewModel: PaymentViewModelType = PaymentViewModel(shippingAddress: selectedAddress, navigationFlow: self)
        let paymentAddressVC = PaymentViewViewController(nibName: "PaymentViewViewController", bundle: nil ,  viewModel: viewModel)
        navigationController.pushViewController(paymentAddressVC, animated: true)
    }
    
    func goToEditAddressScreen(with selectedAddress: CustomerAddress) {
        let addressViewModel: AddressViewModelType = AddressViewModel(addressNavigationFlow: self, cartNavigationFlow: self)
        let newAddressVC = UpdateAddressViewController(with: addressViewModel, selectedAddress: selectedAddress)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(newAddressVC, animated: true)
    }
}

extension ShoppingCartCoordinator: UpdateAddressNavigationFlow {
    func goToAddAddressScreen() {
        let addressViewModel: AddressViewModelType = AddressViewModel(addressNavigationFlow: self, cartNavigationFlow: self)
        let newAddressVC = CreateAddressDetailsViewController(with: addressViewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(newAddressVC, animated: true)
    }
    
    func popEditController() {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.popViewController(animated: true)
    }
    
    func goToUpdateAddressScreen(with address: CustomerAddress) {
        
    }
}
