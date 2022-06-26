//
//  ShoppingCartViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ShoppingCartViewController: UIViewController {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var containerViewForShadow: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var containerViewForSubTotalAndProceedToCheckout: UIView!
    @IBOutlet weak private var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutBTN: UIButton!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak private var shoppingCartTableView: UITableView! {
        didSet {
            shoppingCartTableView.register(UINib(nibName: ShoppingCartTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: ShoppingCartTableViewCell.reuseIdentifier())
        }
    }
    // MARK: - Properties
    //
    private var viewModel: CartViewModel!
    private let disposeBag = DisposeBag()
    let connection = NetworkReachability.shared
    // MARK: - Set up
    //
    init(with viewModel: CartViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        bindProceedToCheckoutTapped()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.checkNetwork(target: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.modifyOrderInCartApi()
    }
    
    private func setupUI() {
        containerViewForSubTotalAndProceedToCheckout.makeCorners(corners: [.topLeft , .topRight], radius: 18)
        containerViewForShadow.applyShadow()
        checkoutBTN.tintColor = ColorsPalette.labelColors
        subTotalLabel.textColor = ColorsPalette.lightColor
        checkoutBTN.configuration?.background.backgroundColor = ColorsPalette.lightColor
        containerViewForSubTotalAndProceedToCheckout.applyShadow()
        totalPriceLabel.textColor = ColorsPalette.lightColor
        containerViewForSubTotalAndProceedToCheckout.backgroundColor = ColorsPalette.labelColors
        let emptyCartGif = UIImage.gifImageWithName("emptyCart")
        emptyImageView.image = emptyCartGif
    }
    // MARK: - Private handlers
    //
    private func bind() {
        guard let viewModel = self.viewModel else {fatalError("Couldn't unwrap viewModel")}
        
        let inputData = Observable.merge(
            rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in }
        )
        shoppingCartTableView.delegate = nil
        shoppingCartTableView.dataSource = nil
        shoppingCartTableView.rx.setDelegate(self).disposed(by: disposeBag)
        shoppingCartTableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              self?.shoppingCartTableView.deselectRow(at: indexPath, animated: true)
          }).disposed(by: disposeBag)
        
        let output = viewModel.bind(CartInput(viewLoaded: inputData))
    
        output.cart.bind(to: shoppingCartTableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)

        output.cartBadge.subscribe { value in
            if(value == "0") {
                self.navigationController?.tabBarItem.badgeValue = nil
            }else {
                self.navigationController?.tabBarItem.badgeValue = value
            }
            
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
        
        output.cartEmpty.bind(to: emptyView.rx.isEmpty())
            .disposed(by: disposeBag)
        
        output.cartTotal.bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindProceedToCheckoutTapped() {
        checkoutBTN.rx.tap
            .subscribe {[weak self] _ in
                guard let `self` = self else {fatalError()}
                if(self.viewModel.checkUserExists()) {
                    self.viewModel.goToAddressesScreen()
                } else {
                    AlertView.showAlertBox(title: "Login Alert", message: "Please you have to login first") { [weak self] action in
                        self?.viewModel.goToGuestTab()
                    }.present(on: self)
                }
                
            }.disposed(by: disposeBag)
        
    }
}



// MARK: - Extensions
extension ShoppingCartViewController {
    
    //MARK: -Private handlers
    //
    private func dataSource() -> RxTableViewSectionedReloadDataSource<CartSection> {
        .init {[weak self] datasource, tableView, indexPath, row in
            let cell: ShoppingCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartTableViewCell.reuseIdentifier(), for: indexPath) as! ShoppingCartTableViewCell
            guard let `self` = self else {fatalError()}
            guard let viewModel = self.viewModel else {fatalError("Couldn't unwrap viewModel")}
            cell.bind(viewModel: CartCellViewModel(row: row),
                      incrementObserver: viewModel.incrementProduct,
                      decrementObserver: viewModel.decrementProduct,
                      deleteObserver: viewModel.deleteProduct)
            cell.delegate = self
           
            return cell
        }
    }
}

//MARK: -Delegates

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
}
