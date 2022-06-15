//
//  LoginViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 17/05/2022.
//
import UIKit
import RxCocoa
import RxSwift
import ProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // MARK: - Properties
    //
    private var loginViewModel: LoginViewModelType!
    private let disposeBag = DisposeBag ()
    
    // MARK: - Set up
    //
    init(_ loginViewModel: LoginViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.loginViewModel = loginViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitleColor(.gray, for: .disabled)
        setupBindings()
        observeViewModelOnValid()
        bindLoginBtn()
        bindErrorLabel()
        bindActivity()
    }
}

// MARK: - Extensions
extension LoginViewController {
    
    // MARK: - Private handlers
    //
    private func bindActivity() {
        loginViewModel.isLoading.drive(ProgressHUD.rx.isAnimating)
        .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        emailTextField.rx.text.bind(to: loginViewModel.emailObservable).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: loginViewModel.passwordObservable).disposed(by: disposeBag)
    }
    
    private func observeViewModelOnValid(){
        loginViewModel.isValidForm.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func bindLoginBtn(){
        loginButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {fatalError()}
            self.loginViewModel.checkCustomerExists(email:self.emailTextField.text!, password:self.passwordTextField.text!)
        }.disposed(by: disposeBag)
    }
    
    private func bindErrorLabel() {
        loginViewModel.emailCheckErrorMessage
            .bind(to: errorMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        loginViewModel.showErrorLabelObserver
            .bind(to: errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindSignupBtn(){
        signupBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {fatalError()}
            self.loginViewModel.goToRegisterScreen()
        }.disposed(by: disposeBag)
    }
}
