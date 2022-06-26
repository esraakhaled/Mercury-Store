//
//  UpdateAddressViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 14/06/2022.
//

import UIKit
import Toast_Swift
import RxSwift
import RxCocoa
import DropDown

class UpdateAddressViewController: UIViewController {
    
    // MARK: - IBOutlets
    //
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var updateAddressBtn: UIButton!
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
    private var selectedAddress: CustomerAddress!
    private let disposeBag = DisposeBag()
    private let dropDown = DropDown()
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(with viewModel: AddressViewModelType, selectedAddress: CustomerAddress) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.selectedAddress = selectedAddress
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAddressBtn.setTitleColor(.gray, for: .disabled)
        setUpUI()
        setupBindings()
        observeViewModelOnValid()
        bindCloseButton()
        observePhoneIsValid()
        observeAddressIsValid()
        observeViewModelOnValid()
        selectedCity()
        observeCityIsValid()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    private func setUpUI() {
        self.updateAddressBtn.tintColor = ColorsPalette.labelColors
        self.updateAddressBtn.configuration?.background.backgroundColor = ColorsPalette.lightColor
        closeButton.tintColor = ColorsPalette.lightColor
        countryTxt.isEnabled = false
        dropDown.anchorView = selectCityButton
        dropDown.dataSource = EgyptCitiesArray.EgyptCities
        self.AddressTxt.text = selectedAddress.address1
        self.phoneTxt.text = selectedAddress.phone
        let index = dropDown.dataSource.firstIndex(of: selectedAddress.city)
        dropDown.selectRow(at: index!)
        self.selectCityButton.titleLabel?.text = selectedAddress.city
        self.viewModel.acceptTitle(selectedAddress.city)
            
        
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
    func  observeViewModelOnValid(){
        viewModel.isValidForm.bind(to: updateAddressBtn.rx.isEnabled).disposed(by: disposeBag)
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
    @IBAction func updateAddrBtn(_ sender: Any) {
        let user = viewModel.getUserFromUserDefaults()
        self.viewModel.updateAddress(AddressRequestItemPut(address1: (self.AddressTxt!.text!), address2: (self.AddressTxt!.text!), city: dropDown.selectedItem!, company: "iti", firstName: user!.username, lastName: user!.username, phone: (self.phoneTxt!.text!), province: dropDown.selectedItem!, country: (self.countryTxt!.text!), zip: "G1R 4P5", name: "\(user!.username)", provinceCode: "Cairo", countryCode: "EG", countryName: "Egypt", id: (self.selectedAddress.id)))
        self.view.makeToast("You Have Updated address!", duration: 3.0, position: .bottom)
    }
}
