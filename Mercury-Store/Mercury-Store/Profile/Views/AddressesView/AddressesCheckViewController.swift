//
//  AddressesCheckViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 16/06/2022.
//

import UIKit
import RxSwift

class AddressesCheckViewController: UIViewController {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var imageForEmptyAddress: UIImageView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: CheckAddressesTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: CheckAddressesTableViewCell.reuseIdentifier())
        }}
    // MARK: - Properties
    //
    private var viewModel: AddressViewModelType!
    private let disposeBag = DisposeBag()
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
        bindTableView()
        bindEmptyView()
        createAddBarButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
        self.viewModel.getAddress()
    }
}
// MARK: - Extensions
extension AddressesCheckViewController {
    // MARK: - Private handlers
    //
    private func createAddBarButtonItem() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.navigationItem.rightBarButtonItem = add
    }
    
    @objc func addBtnTapped() {
        self.viewModel.goToAddAddressScreen()
    }
}
// MARK: - Extensions
extension AddressesCheckViewController {
    // MARK: - Private handlers
    //
    private func bindTableView() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.addresses
            .drive(tableView.rx.items(cellIdentifier: CheckAddressesTableViewCell.reuseIdentifier(), cellType: CheckAddressesTableViewCell.self)) {[weak self] indexPath, item , cell in
                guard let `self` = self else {fatalError()}
                cell.address = item
                if(item.customerAddressDefault == false) {
                    cell.deleteTap
                        .withUnretained(self)
                        .flatMapLatest{ s, _ in s.deleteItem() }
                        .filter { $0 == .default}
                        .map{ _ in item }
                        .subscribe(onNext: { _ in
                            self.viewModel.deleteAddress(with: item)
                        }).disposed(by: cell.disposeBag)
                }else {
                    cell.deleteTap
                        .withUnretained(self)
                        .flatMapLatest{ s, _ in s.deleteDefault() }
                        .filter { $0 == .default}
                        .map{ _ in item }
                        .subscribe(onNext: { _ in
                            
                        }).disposed(by: cell.disposeBag)
                }
                
                cell.editTap.subscribe(onNext: { _ in
                    self.viewModel.goToEditAddressFromCart(with: item)
                }).disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        self.viewModel?.getAddress()
        
        self.tableView.rx.modelSelected(CustomerAddress.self)
            .subscribe { [weak self] selectedAddress in
                self?.viewModel.goToPaymentFromSelectedAddress(selectedAddress)
            }.disposed(by: disposeBag)
        
    }
    
    private func bindEmptyView() {
        self.viewModel.empty
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
// MARK: - Extensions
extension AddressesCheckViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension AddressesCheckViewController {
    fileprivate func deleteItem() -> Observable<UIViewController.AlertAction> {
        return alert(title: "Delete Address",
                     message: "Would you like to delete this address?",
                     defaultTitle: "OK",
                     cancelTitle: "Cancel")
    }
    
    fileprivate func deleteDefault() -> Observable<UIViewController.AlertAction> {
        return alertWithOneButton(title: "Delete Address",
                                  message: "You cannot delete your default address",
                                  defaultTitle: "OK")
    }
}

