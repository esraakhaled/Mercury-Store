//
//  ProfileCoordinator.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import Foundation
import UIKit


class ProfileCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ProfileViewModel(profileNavigationFlow: self)
        let profileVC = ProfileViewController(with: viewModel)
        navigationController.pushViewController(profileVC, animated: true)
    }
}

extension ProfileCoordinator: ProfileNavigationFlow {
    func goToMyOrdersScreen() {
        let customersOrderScreen = myOrdersTableViewController(CustomersOrdersViewModels())
        self.navigationController.pushViewController(customersOrderScreen, animated: true)
        
    }
    
    func goToMyWishListScreen() {
        let myWishListVC = WishListViewController(nibName: String(describing: WishListViewController.self), bundle: nil)
        
        self.navigationController.pushViewController(myWishListVC, animated: true)
    }
    
    func goToMyAddressesScreen() {
        let addressesViewModel : AddressViewModelType = AddressViewModel(addressNavigationFlow: self, cartNavigationFlow: self)
       
      let myAddressesVC = AddressViewController(addressesViewModel)
        
        self.navigationController.pushViewController(myAddressesVC, animated: true)
        
    }
    
    func goToAboutUsScreen() {
        let aboutUsVC = AboutUsViewController(nibName: String(describing: AboutUsViewController.self), bundle: nil)
        
        self.navigationController.pushViewController(aboutUsVC, animated: true)
    }
    func goToMainTab() {
        UserDefaults.standard.removeObject(forKey: "user")
        CartCoreDataManager.shared.deleteAll()
        let appC = self.parentCoordinator?.parentCoordinator as! ApplicationCoordinator
        appC.goToHomeTabbar()
        appC.childDidFinish(self)
    }
    
}

extension ProfileCoordinator: UpdateAddressNavigationFlow {
    func goToAddAddressScreen() {
        let addressViewModel: AddressViewModelType = AddressViewModel(addressNavigationFlow: self, cartNavigationFlow: self)
        let newAddressVC = CreateAddressDetailsViewController(with: addressViewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(newAddressVC, animated: true)
    }
    
    func goToUpdateAddressScreen(with address: CustomerAddress) {
        let addressViewModel: AddressViewModelType = AddressViewModel(addressNavigationFlow: self, cartNavigationFlow: self)
        let newAddressVC = UpdateAddressViewController(with: addressViewModel, selectedAddress: address)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(newAddressVC, animated: true)
        
    }
    
    func popEditController() {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.popViewController(animated: true)
    }
}

extension ProfileCoordinator : ShoppingCartNavigationFlow {
    func goToEditAddressScreen(with selectedAddress: CustomerAddress) {
        
    }
    
    func popToRoot() {
        
    }
    
    func goToAddressesScreen() {
        
    }
    
    func goToGuestTab() {
        
    }
    
    func goToPaymentScreen(selectedAddress: CustomerAddress) {
        
    }
}
    

    

