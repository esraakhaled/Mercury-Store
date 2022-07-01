//
//  AddressViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 21/05/2022.
//

import UIKit
import RxCocoa
import RxSwift

class AddressViewController: UIViewController, UIScrollViewDelegate{
    // MARK: - IBOutlets
    //
    @IBOutlet weak var addAddrLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: AddressTVCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: AddressTVCell.reuseIdentifier())
        }}
    // MARK: - Properties
    //
    let disposeBag = DisposeBag()
    private var viewModel: AddressViewModelType!
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(_  viewModel: AddressViewModelType){
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
        self.configure()
        createAddBarButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
        self.viewModel?.getAddress()
    }
    
}
// MARK: - Extensions
extension AddressViewController {
    // MARK: - Private handlers
    //
    private func bindTableView() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.addresses
            .drive(tableView.rx.items(cellIdentifier: AddressTVCell.reuseIdentifier(), cellType: AddressTVCell.self)) {[weak self] indexPath, item , cell in
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
                    self.viewModel.goToEditAddressScreen(with: item)
                }).disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        self.viewModel?.getAddress()
    }
    
    private func bindEmptyView() {
        self.viewModel.empty
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
  
}
// MARK: - Extensions
extension AddressViewController {
    // MARK: - Private handlers
    //
    private func configure() {
        self.bindTableView()
        self.bindEmptyView()
    }
}
// MARK: - Extensions
extension AddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension AddressViewController {
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
// MARK: - Extensions
 extension AddressViewController {
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
