//
//  AddressViewModel.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 13/06/2022.
//
import Foundation
import RxSwift
import RxCocoa

protocol AddressViewModelType {
    
    var cityObservable: AnyObserver<String?> { get }
    var addressObservable: AnyObserver<String?> { get }
    var phoneObservable: AnyObserver<String?> { get }
    var isValidForm: Observable<Bool> { get }
    var isNotEmptyAddress: Observable<Bool> { get }
    var isNotValidPhone: Observable<Bool> { get }
    var isNotValidCity: Observable<Bool>  { get }
    var addresses: Driver<[CustomerAddress]> {get}
    var addressErrorMessage: AnyObserver<String?> { get }
    var deleteAddress: AnyObserver<CustomerAddress> { get }
    var empty: Driver<Bool> { get }
    func postAddress(_ address:AddressRequestItem)
    func getAddress()
    func getUserFromUserDefaults() -> User?
    func updateAddress(_ address:AddressRequestItemPut)
    func goToEditAddressScreen(with address: CustomerAddress)
    func popViewController()
    func goToAddAddressScreen()
    func goToPaymentFromSelectedAddress(_ selectedAddress: CustomerAddress)
    func acceptTitle(_ title: String)
    func deleteAddress(with address: CustomerAddress)
    func goToEditAddressFromCart(with address: CustomerAddress)
}
class AddressViewModel: AddressViewModelType {
    
    private let citySubject = BehaviorSubject<String?>(value: "")
    private let addressSubject = BehaviorSubject<String?>(value: "")
    private let phoneSubject = BehaviorSubject<String?>(value: "")
    private let disposeBag = DisposeBag()
    var addresses: Driver<[CustomerAddress]>
    private let addressProvider: AddressProvider
    private let addressRequestPost:PublishSubject<AddressResponse> = PublishSubject<AddressResponse>()
    private let addressRequestGett:PublishSubject = PublishSubject<[CustomerAddress]>()
    private let addressRequestPostError = PublishSubject<Error>()
    private let showErrorMessage = BehaviorSubject<String?>(value: "")
    private let showErrorLabelSubject = BehaviorSubject<Bool>(value: true)
    private weak var addressNavigationFlow : UpdateAddressNavigationFlow?
    private weak var cartNavigationFlow: ShoppingCartNavigationFlow?
    private let emptySubject = BehaviorRelay<Bool>(value: true)
    private let deleteAddressSubject = PublishSubject<CustomerAddress>()
    
    
    var empty: Driver<Bool> {
        return emptySubject
            .asDriver(onErrorJustReturn: true)
    }
    
    var cityObservable: AnyObserver<String?> { citySubject.asObserver() }
    
    var addressObservable: AnyObserver<String?> { addressSubject.asObserver() }
    
    var phoneObservable: AnyObserver<String?> { phoneSubject.asObserver() }
    var addressErrorMessage: AnyObserver<String?> { showErrorMessage.asObserver() }
    
    var isValidForm: Observable<Bool> {
        return Observable.combineLatest( citySubject,addressSubject, phoneSubject) { city, address, phone in
            guard city != nil && address != nil && phone != nil  else {
                return false
            }
            return !(city!.isEmpty) && !(phone!.isEmpty) && !(address!.isEmpty) && phone!.isValidPhone()
        }
    }
    
    var isNotEmptyAddress: Observable<Bool> {
        return Observable.combineLatest(addressSubject,showErrorMessage) { address,errorMessage  in
            return !(address!.isEmpty)
        }
    }
    
    var isNotValidPhone: Observable<Bool> {
        return Observable.combineLatest(phoneSubject,showErrorMessage) { phone,errorMessage  in
            return  !(phone!.isEmpty) && phone!.isValidPhone()
        }
    }
    
    var isNotValidCity: Observable<Bool> {
        return Observable.combineLatest(citySubject,showErrorMessage) { city,errorMessage  in
            return !(city!.isEmpty)
        }
    }
    
    var deleteAddress: AnyObserver<CustomerAddress> { deleteAddressSubject.asObserver() }
    
    init(_ addressProvider: AddressProvider = AddressClient(),
         addressNavigationFlow: UpdateAddressNavigationFlow,
         cartNavigationFlow: ShoppingCartNavigationFlow
    ) {
        self.addressProvider = addressProvider
        self.addressNavigationFlow = addressNavigationFlow
        self.cartNavigationFlow = cartNavigationFlow
        addresses = addressRequestGett.asDriver(onErrorJustReturn: [])
    }
    
    func acceptTitle(_ title: String) {
        citySubject.onNext(title)
    }
    
    func goToEditAddress(with address: CustomerAddress) {
        self.addressNavigationFlow?.goToUpdateAddressScreen(with: address)
    }
    func goToEditAddressFromCart(with address: CustomerAddress) {
        self.cartNavigationFlow?.goToEditAddressScreen(with: address)
    }
    func goToAddAddressScreen() {
        self.addressNavigationFlow?.goToAddAddressScreen()
    }
    
    func postAddress( _ address:AddressRequestItem){
        let user = getUserFromUserDefaults()
        addressProvider.postAddress(with: user!.id, addressRequest: AddressRequest(address: address))
            .subscribe(onNext: { [weak self] result in
                guard let `self` = self else {fatalError()}
                self.addressRequestPost.onNext(result)
                self.addressNavigationFlow?.popEditController()
            }, onError: { [weak self] error in
                guard let `self` = self else {fatalError()}
                self.addressRequestPostError.onNext(error)
                self.showErrorLabelSubject.onNext(false)
                self.showErrorMessage.onNext(CustomerErrors.newAddressError.rawValue)
            })
            .disposed(by: disposeBag)
    }
    
    func updateAddress(_ address:AddressRequestItemPut){
        let user = getUserFromUserDefaults()
        addressProvider.putAddress(with:  user!.id, with: address.id, addressRequest: AddressRequestPut(address: address))
            .subscribe(onNext: { [weak self] result in
                guard let `self` = self else {fatalError()}
                self.addressRequestPost.onNext(result)
                self.addressNavigationFlow?.popEditController()
            }, onError: { [weak self] error in
                guard let `self` = self else {fatalError()}
                self.addressRequestPostError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getAddress() {
        let user = getUserFromUserDefaults()
        addressProvider.getAddress(with:  user!.id)
            .subscribe(onNext: { [weak self] result in
                guard let `self` = self else {fatalError()}
                if (result.addresses.isEmpty) {
                    self.emptySubject.accept(false)
                } else {
                    self.emptySubject.accept(true)
                    self.addressRequestGett.onNext(result.addresses)
                }
            }, onError: { [weak self] error in
                guard let `self` = self else {fatalError()}
                self.addressRequestPostError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAddress(with address: CustomerAddress) {
        let user = getUserFromUserDefaults()
        deleteAddressSubject.onNext(address)
        addressProvider.deleteAddress(with: user!.id, and: address.id)
            .subscribe { [weak self] _ in
                guard let `self` = self else {fatalError()}
                self.getAddress()
            }.disposed(by: disposeBag)

    }
    
    func getUserFromUserDefaults() -> User? {
        do {
            return try UserDefaults.standard.getObject(forKey: "user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func goToEditAddressScreen(with address: CustomerAddress) {
        self.addressNavigationFlow?.goToUpdateAddressScreen(with: address)
    }
    
    func popViewController() {
        self.addressNavigationFlow?.popEditController()
    }
    func goToPaymentFromSelectedAddress(_ selectedAddress: CustomerAddress) {
        self.cartNavigationFlow?.goToPaymentScreen(selectedAddress: selectedAddress)
    }
}
