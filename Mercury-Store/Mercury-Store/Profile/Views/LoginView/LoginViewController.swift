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
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLabelOnEmail: UILabel!
    @IBOutlet weak var errorLabelOnPassword: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    
    // MARK: - Properties
    //
    private var loginViewModel: LoginViewModelType!
    private let disposeBag = DisposeBag ()
    let connection = NetworkReachability.shared
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
        loginBtn.setTitleColor(.gray, for: .disabled)
        setUpUI()
        setupBindings()
        observeViewModelOnValid()
        bindLoginBtn()
        bindErrorLabel()
        bindSignupBtn()
        bindActivity()
        
        observeEmailIsValid()
        observePasswordIsValid()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    private func setUpUI() {
        self.loginBtn.tintColor = ColorsPalette.labelColors
        self.loginBtn.configuration?.background.backgroundColor = ColorsPalette.lightColor
        signupBtn.tintColor = ColorsPalette.lightColor
    }
}

// MARK: - Extensions
extension LoginViewController {
    
    // MARK: - Private handlers
    //
    private func setupBindings() {
        emailTxt.rx.text.bind(to: loginViewModel.emailObservable).disposed(by: disposeBag)
        passwordTxt.rx.text.bind(to: loginViewModel.passwordObservable).disposed(by: disposeBag)
    }
    
    private func bindActivity() {
        loginViewModel.isLoading.drive(ProgressHUD.rx.isAnimating)
        .disposed(by: disposeBag)
    }
    
    private func observeViewModelOnValid(){
        loginViewModel.isValidForm.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    func observeEmailIsValid() {
        loginViewModel.isNotValidEmail.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnEmail.text = isValid ? "Valid Email" : "Please fill email"
            self?.errorLabelOnEmail.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    
    func observePasswordIsValid() {
        loginViewModel.isNotValidPassword.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnPassword.text = isValid ? "Valid password" : "Please enter a valid password"
            self?.errorLabelOnPassword.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    private func bindLoginBtn(){
        loginBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else {fatalError()}
            self.loginViewModel.checkCustomerExists(email:self.emailTxt.text!, password:self.passwordTxt.text!)
        }).disposed(by: disposeBag)
    }
    
     private func bindErrorLabel() {
        loginViewModel.emailCheckErrorMessage
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        loginViewModel.showErrorLabelObserver
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindSignupBtn(){
        signupBtn.rx.tap.subscribe { [weak self] _ in
            self?.loginViewModel.goToRegisterScreen()
        }.disposed(by: disposeBag)
    }
}
