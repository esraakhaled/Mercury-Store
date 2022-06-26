//
//  CreateAddressDetailsViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 22/05/2022.
//

import UIKit
import Toast_Swift
import RxSwift
import RxCocoa
import DropDown

class CreateAddressDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var AddressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var errorLabelOnAddress: UILabel!
    @IBOutlet weak var errorLabelOnPhone: UILabel!
    @IBOutlet weak var errorLabelOnCity: UILabel!
    @IBOutlet weak var selectCityButton: UIButton!
    
    // MARK: - Properties
    //
    private var viewModel: AddressViewModelType!
    private let disposeBag = DisposeBag()
    private let dropDown = DropDown()
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(with viewModel: AddressViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupBindings()
        observeViewModelOnValid()
        bindCloseButton()
        observePhoneIsValid()
        observeAddressIsValid()
        selectedCity()
        observeCityIsValid()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    private func setUpUI() {
        self.addAddressBtn.tintColor = ColorsPalette.labelColors
        self.addAddressBtn.configuration?.background.backgroundColor = ColorsPalette.lightColor
        closeButton.tintColor = ColorsPalette.lightColor
        countryTxt.isEnabled = false
        dropDown.anchorView = selectCityButton
        dropDown.dataSource = EgyptCitiesArray.EgyptCities
    }
    // MARK: - Private handlers
    //
    private func bindCloseButton() {
        closeButton.rx.tap
            .subscribe {[weak self] _ in
                self?.viewModel.popViewController()
            }.disposed(by: disposeBag)
    }
    func setupBindings() {
        AddressTxt.rx.text.bind(to: viewModel.addressObservable).disposed(by: disposeBag)
        phoneTxt.rx.text.bind(to: viewModel.phoneObservable).disposed(by: disposeBag)
    }
    
    func observeAddressIsValid() {
        viewModel.isNotEmptyAddress.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnAddress.text = isValid ? "Valid Address" : "Please fill address"
            self?.errorLabelOnAddress.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    
    func observePhoneIsValid() {
        viewModel.isNotValidPhone.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnPhone.text = isValid ? "Valid Phone" : "Please enter a valid phone"
            self?.errorLabelOnPhone.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    
    func observeCityIsValid() {
        viewModel.isNotValidCity.subscribe(onNext: {[weak self] isValid in
            self?.errorLabelOnCity.text = isValid ? "Valid city" : "Please select a city"
            self?.errorLabelOnCity.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
    }
    
    func observeViewModelOnValid(){
        viewModel.isValidForm.bind(to: addAddressBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func selectedCity() {
        selectCityButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dropDown.selectionAction = { (index: Int, item: String) in
                self?.selectCityButton.titleLabel?.text = item
                self?.viewModel.acceptTitle(item)
            }
            self?.dropDown.cancelAction = { [unowned self] in
                self?.viewModel.acceptTitle("")
            }
            self?.dropDown.width = self?.view.bounds.width
            self?.dropDown.direction = .bottom
            self?.dropDown.show()
        }).disposed(by: disposeBag)
        
    }
    // MARK: - IBActions
    @IBAction func didPressedOnAddAddress(_ sender: Any) {
        let user = viewModel.getUserFromUserDefaults()
        
        self.viewModel.postAddress(AddressRequestItem(address1: (self.AddressTxt!.text)!, address2: (self.AddressTxt!.text)!, city: dropDown.selectedItem!, company: "iti", firstName:user!.username, lastName: user!.username, phone: (self.phoneTxt!.text!), province: dropDown.selectedItem! , country: (self.countryTxt!.text!), zip: "G1R 4P5", name: "\(user!.username)", provinceCode: "Cairo", countryCode: "EG", countryName: "Egypt"))
        self.view.makeToast("You Have Created address!", duration: 3.0, position: .bottom)
        
        
    }
    
    
    
}
