//
//  RegisterViewModel.swift
//  Mercury-Store
//
//  Created by Esraa Khaled on 30/05/2022.
//

import RxSwift
import RxCocoa

protocol RegisterViewModelType {
    var firstNameObservable: AnyObserver<String?> { get }
    var secondNameObservable: AnyObserver<String?> { get }
    var emailObservable: AnyObserver<String?> { get }
    var passwordObservable: AnyObserver<String?> { get }
    var confirmPasswordObservable: AnyObserver<String?> { get }
    var isValidForm: Observable<Bool> { get }
    var isNotEmptyFirstname: Observable<Bool> { get }
    var isNotEmptyLastname: Observable<Bool> { get }
    var isNotValidEmail: Observable<Bool> { get }
    var isNotValidPassword: Observable<Bool>  { get }
    var isNotValidConfirmPassword: Observable<Bool>  { get }
    var errorMessage: AnyObserver<String?> { get }
    var registerErrorMessage: AnyObserver<String?> { get }
    var isLoading: Driver<Bool> { get }
    var emailCheckErrorMessage: Observable<String?> { get }
    var showErrorLabelObserver: Observable<Bool> { get }
    func checkCustomerExists(firstName: String, lastName: String, email: String, password: String)
    func goToLoginScreen()
}

class RegisterViewModel: RegisterViewModelType {
    //MARK: - Private properties
    //
    private weak var guestNavigationFlow: GuestNavigationFlow?
    private let firstNameSubject = BehaviorSubject<String?>(value: "")
    private let secondNameSubject = BehaviorSubject<String?>(value: "")
    private let emailSubject = BehaviorSubject<String?>(value: "")
    private let passwordSubject = BehaviorSubject<String?>(value: "")
    private let confirmPasswordSubject = BehaviorSubject<String?>(value: "")
    private let disposeBag = DisposeBag()
    private let minPasswordCharacters = 6
    private let customerProvider: CustomerProvider
    private let customerRequestPost:PublishSubject<RegisterResponse> = PublishSubject<RegisterResponse>()
    private let customerRequestPostError = PublishSubject<Error>()
    private let showErrorMessage = PublishSubject<String?>()
    private let showErrorLabelSubject = BehaviorSubject<Bool>(value: true)
    private let sharedInstance: UserDefaults
    private let isLoadingSubject = BehaviorRelay<Bool> (value: false)
    private let emptySubject = BehaviorRelay<Bool>(value: true)
    private let showError = BehaviorSubject<String?>(value: "")
    
  
    //MARK: - Public properties
    //
    var empty: Driver<Bool> {
        return emptySubject
            .asDriver(onErrorJustReturn: true)
    }
    var firstNameObservable: AnyObserver<String?> { firstNameSubject.asObserver() }
    
    var secondNameObservable: AnyObserver<String?> { secondNameSubject.asObserver() }
    
    var emailObservable: AnyObserver<String?> { emailSubject.asObserver() }
    
    var passwordObservable: AnyObserver<String?> { passwordSubject.asObserver() }
    
    var confirmPasswordObservable: AnyObserver<String?> { confirmPasswordSubject.asObserver() }
    
    var registerErrorMessage: AnyObserver<String?> { showErrorMessage.asObserver() }
    
    var emailCheckErrorMessage: Observable<String?> { showErrorMessage.asObservable() }
    
    var showErrorLabelObserver: Observable<Bool> { showErrorLabelSubject.asObservable() }
    
    var isLoading: Driver<Bool> { isLoadingSubject.asDriver(onErrorJustReturn: false) }
    
    var errorMessage: AnyObserver<String?> { showError.asObserver() }
    
    var isValidForm: Observable<Bool> {
        return Observable.combineLatest( firstNameSubject, secondNameSubject,emailSubject, passwordSubject,confirmPasswordSubject) { firstName, secondName, email, password, confirmPassword in
            guard firstName != nil && secondName != nil && email != nil && password != nil && confirmPassword != nil else {
                return false
            }
            return !(firstName!.isEmpty) &&  !(secondName!.isEmpty) && email!.validateEmail() && password!.count >= self.minPasswordCharacters && confirmPassword!.count >= self.minPasswordCharacters
        }
    }
    var isNotEmptyFirstname: Observable<Bool> {
        return Observable.combineLatest(firstNameSubject,showError) { firstName,errorMessage  in
            return !(firstName!.isEmpty)
        }
    }
    
    var isNotEmptyLastname: Observable<Bool> {
        return Observable.combineLatest(secondNameSubject,showError) { lastName,errorMessage  in
            return  !(lastName!.isEmpty)
        }
    }
    
    var isNotValidEmail: Observable<Bool> {
        return Observable.combineLatest(emailSubject,showError) { email,errorMessage  in
            return !(email!.isEmpty) && (email!.validateEmail())
        }
    }
    var isNotValidPassword: Observable<Bool> {
        return Observable.combineLatest(passwordSubject,showError) { password,errorMessage  in
            return !( password!.isEmpty) && password!.count >= self.minPasswordCharacters
        }
    }
    var isNotValidConfirmPassword: Observable<Bool> {
        return Observable.combineLatest(confirmPasswordSubject, showError, passwordSubject) { confirmPassword,errorMessage, password  in
            return !(confirmPassword!.isEmpty) && password == confirmPassword
        }
    }
    //MARK: - Initialiser
    //
    init(_ customerProvider: CustomerProvider = CustomerClient(), flow: GuestNavigationFlow, sharedInstance: UserDefaults = UserDefaults.standard) {
        self.customerProvider = customerProvider
        self.guestNavigationFlow = flow
        self.sharedInstance = sharedInstance
    }
}


// MARK: - Extensions
//
extension RegisterViewModel {
    //MARK: - Public Handlers
    //
    func checkCustomerExists(firstName: String, lastName: String, email: String, password: String) {
        self.isLoadingSubject.accept(true)
        customerProvider.checkEmailExists(email)
            .subscribe(onNext: { [weak self] result in
                guard let `self` = self else {fatalError()}
                if(result.customers.isEmpty) {
                    self.postCustomer(firstName: firstName, lastName: lastName, email: email, password: password)
                    self.isLoadingSubject.accept(false)
                } else {
                    self.showErrorLabelSubject.onNext(false)
                    self.isLoadingSubject.accept(false)
                    self.showErrorMessage.onNext(CustomerErrors.emailExists.rawValue)
                }
                
            }, onError: { [weak self] error in
                guard let `self` = self else {fatalError()}
                self.customerRequestPostError.onNext(error)
                self.isLoadingSubject.accept(false)
            }).disposed(by: disposeBag)
    }
   func validateEmailCorrect(email:String){
        if(email.validateEmail()) {
            
        } else {
            self.showErrorLabelSubject.onNext(false)
            self.showErrorMessage.onNext(CustomerErrors.emailIsNotValid.rawValue)
        }
        
    }
    
    
    // MARK: - Navigation
    //
    func goToLoginScreen() {
        self.guestNavigationFlow?.goToLoginScreen()
    }
    
}

extension RegisterViewModel {
    //MARK: - Private Handlers
    //
    private func postCustomer(firstName: String, lastName: String, email: String, password: String) {

        customerProvider.postCustomer(
            Customer(customer: CustomerClass(firstName: firstName, lastName: lastName, email: email, password: password, cartId: "0", favouriteId: "0"
                                            )))
        .subscribe(onNext: { [weak self] result in
            guard let `self` = self else {fatalError()}
            self.customerRequestPost.onNext(result)
            self.saveCredentialsInUserDefaults(customer: result.customer)
            self.goToProfileScreen(result.customer.id)
            self.isLoadingSubject.accept(false)
        }, onError: { [weak self] error in
            guard let `self` = self else {fatalError()}
            self.isLoadingSubject.accept(false)
            self.customerRequestPostError.onNext(error)
        })
        .disposed(by: disposeBag)
    }
    
    
    private func goToProfileScreen(_ id: Int) {
        self.guestNavigationFlow?.isLoggedInSuccessfully(id)
    }
    
    private func saveCredentialsInUserDefaults(customer: CustomerResponse) {
        let user = fromCustomerToUser(customer)
        do {
            try sharedInstance.setObject(user, forKey: "user")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fromCustomerToUser(_ customer: CustomerResponse) -> User {
        return User(id: customer.id, email: customer.email, username: customer.firstName, isLoggedIn: true, isDiscount: false, password: customer.password, cartId: Int(customer.cartId ) ?? 0, favouriteId: Int(customer.favouriteId ) ?? 0)
    }
}
