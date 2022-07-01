//
//  myOrdersTableViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 23/05/2022.
//

import UIKit
import RxSwift

class myOrdersTableViewController: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var orderTableView: UITableView!
    private var ordersViewModel:CustomersOrdersViewModelsType!
    private let disposeBag = DisposeBag()
    private weak var orderDetailNavigation: OrdersNavigationFlow?
    
    init(_ viewModel: CustomersOrdersViewModelsType = CustomersOrdersViewModels(),orderDetailNavigation: OrdersNavigationFlow ) {
        super.init(nibName: nil, bundle: nil)
        self.ordersViewModel = viewModel
        self.orderDetailNavigation = orderDetailNavigation
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.bindEmptyView()
    }
}
extension myOrdersTableViewController: UITableViewDelegate{
    private func setupTable(){
        orderTableView.register(UINib(nibName: "MyOrdersViewCell", bundle: nil), forCellReuseIdentifier: "myOrderCell")
        orderTableView.dataSource = nil
        orderTableView.delegate = nil
        orderTableView.rx.setDelegate(self).disposed(by: disposeBag)
        ordersViewModel.orders.drive(orderTableView.rx.items(
            cellIdentifier: "myOrderCell", cellType: MyOrdersViewCell.self)){index , element ,cell in
                cell.setupCell(order: element)
            }.disposed(by: disposeBag)
        
        orderTableView.rx.modelSelected(CustomerOrders.self).subscribe (onNext: {[weak self] item in
            guard let `self` = self else {return}
            self.orderDetailNavigation?.goToOrderDetails(with: item)
        }).disposed(by: disposeBag)

        
    }
    private func bindEmptyView() {
        self.ordersViewModel.empty
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
