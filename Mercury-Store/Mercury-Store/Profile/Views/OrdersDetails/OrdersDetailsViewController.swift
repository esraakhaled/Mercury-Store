//
//  OrdersDetailsViewController.swift
//  Mercury-Store
//
//  Created by mac hub on 29/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class OrdersDetailsViewController: UIViewController {
    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var paymentStatusLabel: UILabel!
    
    @IBOutlet weak var shippingAddressLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var orderItemsTableView: UITableView! {
        didSet {
            orderItemsTableView.register(UINib(nibName: OrderItemsTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: OrderItemsTableViewCell.reuseIdentifier())
        }
    }
    
    private var order: CustomerOrders!
    private let disposeBag = DisposeBag()
    private let lineOfItemsSubject = PublishSubject<[OrdersInfoLineItem]>()
    private var lineOfItems: Driver<[OrdersInfoLineItem]> { lineOfItemsSubject.asDriver(onErrorJustReturn: [])}
    
    init(order: CustomerOrders) {
        super.init(nibName: nil, bundle: nil)
        self.order = order
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindItemsTableView()
        sendDataToTable()
    }
    
    private func sendDataToTable() {
        self.lineOfItemsSubject.onNext(order.lineItems)
    }
    
    private func setupUI() {
        orderIdLabel.text = "\(order.id)"
        dateLabel.text = "\(order.createdAt.formatted(.dateTime))"
        if order.financialStatus == "paid"{
            paymentStatusLabel.text = "paid with paypal"
        }else{
            paymentStatusLabel.text = "cash on Delivery"
        }
        shippingAddressLabel.text = "\(order.shippingAddress?.city  ?? "") - \(order.shippingAddress?.province ?? "")"
        totalPriceLabel.text = CurrencyHelper().checkCurrentCurrency("\(order.totalPrice)")
        discountLabel.text = CurrencyHelper().checkCurrentCurrency("\(order.totalDiscounts ?? "0" )")
    }
    
    private func bindItemsTableView() {
        orderItemsTableView.delegate = nil
        orderItemsTableView.dataSource = nil
        orderItemsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.lineOfItems.drive(orderItemsTableView.rx.items(cellIdentifier: OrderItemsTableViewCell.reuseIdentifier(), cellType: OrderItemsTableViewCell.self)) { index , item, cell in
            cell.item = item
        }.disposed(by: disposeBag)
    }
}

extension OrdersDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


