//
//  ProfileViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import RxSwift
import RxCocoa

protocol ProfileNavigationFlow: AnyObject {
    func goToMyOrdersScreen()
    func goToMyWishListScreen()
    func goToMyAddressesScreen()
    func goToAboutUsScreen()
    func goToMainTab()
}

class ProfileViewModel {
    weak var profileNavigationFlow: ProfileNavigationFlow!
    private var _sectionModels: BehaviorSubject<[ProfileSectionModel]> = BehaviorSubject(value: [])
    private let sharedInstance: UserDefaults
    init(profileNavigationFlow: ProfileNavigationFlow,sharedInstance: UserDefaults = UserDefaults.standard) {
        self.profileNavigationFlow = profileNavigationFlow
        self.sharedInstance = sharedInstance
    }
    var sectionModels: SharedSequence<DriverSharingStrategy, [ProfileSectionModel]> {
        return _sectionModels.asDriver(onErrorJustReturn: [])
    }
    func configureSectionModel() {
        let sections: [ ProfileSectionModel] = [
            .myAccountSection(title: "My Account", items: [
                .myAccountItem(image: UIImage(systemName: "bag")! , title: "My Orders"),
                .myAccountItem(image:  UIImage(systemName: "heart")!, title: "My WishList"),
                .myAccountItem(image:  UIImage(systemName: "homekit")!, title: "My Addresses")
            ]),
            .aboutSection(title: "About", items: [
                .aboutItem(image:  UIImage(systemName: "info.circle")!, title: "About Us")
                
            ])
        ]
        _sectionModels.onNext(sections)
    }
    func getUserInfo() -> User? {
        do{
            let user:User = try sharedInstance.getObject(forKey: "user", castTo: User.self)
            return user
        }catch( _){
            return nil
        }
    }
}


extension ProfileViewModel: ProfileNavigationFlow {
    func goToMyOrdersScreen() {
        self.profileNavigationFlow.goToMyOrdersScreen()
    }
    
    func goToMyWishListScreen() {
        self.profileNavigationFlow.goToMyWishListScreen()
    }
    
    func goToMyAddressesScreen() {
        self.profileNavigationFlow.goToMyAddressesScreen()
    }
    func goToAboutUsScreen() {
        self.profileNavigationFlow.goToAboutUsScreen()
    }
    func goToMainTab() {
        self.profileNavigationFlow.goToMainTab()
    }
}
