//
//  RegisterViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 17/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import ProgressHUD

class RegisterViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var errorLabelOnFirstName: UILabel!
    @IBOutlet weak var errorLabelOnSecondName: UILabel!
    @IBOutlet weak var errorLabelOnEmail: UILabel!
    @IBOutlet weak var errorLabelOnPassword: UILabel!
    @IBOutlet weak var errorLabelOnConfirmPassword: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    //MARK: - Private variables
    //
    private var registerViewModel: RegisterViewModelType!
    private let disposeBag = DisposeBag()
    let connection = NetworkReachability.shared
    //MARK: - Init
    //
    init(_ registerViewModel: RegisterViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.registerViewModel = registerViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.setTitleColor(.gray, for: .disabled)
        setUpUI()
        setupBindings()
        observeViewModelOnValid()
        bindSignUpBtn()
        observeFirstNameIsValid()
        observeLastNameIsValid()
        observeEmailIsValid()
        observePasswordIsValid()
        observeConfirmPasswordIsValid()
        bindLoginButton()
        bindErrorLabel()
        bindActivity()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    //MARK: - Private Handlers
    //
    private func bindActivity() {
        registerViewModel.isLoading.drive(ProgressHUD.rx.isAnimating)
        .disposed(by: disposeBag)
    }
    
    private func setUpUI() {
        self.signupBtn.tintColor = ColorsPalette.labelColors
        self.signupBtn.configuration?.background.backgroundColor = ColorsPalette.lightColor
        signInBtn.tintColor = ColorsPalette.lightColor
    }
    
    private func setupBindings() {
        // 3
        // bind textfields to viewModel for validation and process
        firstNameTxt.rx.text
            .bind(to: registerViewModel.firstNameObservable)
            .disposed(by: disposeBag)
        
        
        lastNameTxt.rx.text
            .bind(to: registerViewModel.secondNameObservable)
            .disposed(by: disposeBag)
        
        emailTxt.rx.text
            .bind(to: registerViewModel.emailObservable)
            .disposed(by: disposeBag)
        
        passwordTxt.rx.text
            .bind(to: registerViewModel.passwordObservable)
            .disposed(by: disposeBag)
        
        confirmPasswordTxt.rx.text
            .bind(to: registerViewModel.confirmPasswordObservable)
            .disposed(by: disposeBag)
        
    }
    
    private func observeViewModelOnValid() {
        registerViewModel.isValidForm.bind(to:  signupBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindSignUpBtn() {
        signupBtn.rx.tap
            .subscribe {[weak self] _ in
                self?.registerViewModel.checkCustomerExists(firstName: self!.firstNameTxt.text!, lastName: self!.lastNameTxt.text!, email: self!.emailTxt.text!, password: self!.passwordTxt.text!)
        }.disposed(by: disposeBag)
        
    }
    
   private func bindErrorLabel() {
        registerViewModel.emailCheckErrorMessage
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        registerViewModel.showErrorLabelObserver
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func bindLoginButton() {
        signInBtn.rx.tap.subscribe { [weak self] _ in
            self?.registerViewModel.goToLoginScreen()
        }.disposed(by: disposeBag)
    }
    func observeFirstNameIsValid() {
        registerViewModel.isNotEmptyFirstname.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnFirstName.text = isValid ? "Valid FirstName" : "Please fill firstName"
            self?.errorLabelOnFirstName.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    func observeLastNameIsValid() {
        registerViewModel.isNotEmptyLastname.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnSecondName.text = isValid ? "Valid LastName" : "Please fill lastName"
            self?.errorLabelOnSecondName.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    func observeEmailIsValid() {
        registerViewModel.isNotValidEmail.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnEmail.text = isValid ? "Valid Email" : "Please fill email"
            self?.errorLabelOnEmail.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    func observePasswordIsValid() {
        registerViewModel.isNotValidPassword.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnPassword.text = isValid ? "Valid Password" : "Please fill password"
            self?.errorLabelOnPassword.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    func observeConfirmPasswordIsValid() {
        registerViewModel.isNotValidConfirmPassword.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnConfirmPassword.text = isValid ? "Valid ConfirmPassword" : "Please fill confirmPassword"
            self?.errorLabelOnConfirmPassword.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
}
