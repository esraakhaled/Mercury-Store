//
//  myOrdersTableViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 23/05/2022.
//

import UIKit
import RxSwift

class myOrdersTableViewController: UITableViewController {
    
    private var ordersViewModel:CustomersOrdersViewModelsType!
    let disposeBag = DisposeBag()

    init(_ viewModel: CustomersOrdersViewModelsType = CustomersOrdersViewModels()) {
        super.init(nibName: nil, bundle: nil)
        self.ordersViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
    }
}
extension myOrdersTableViewController{
    private func setupTable(){
        tableView.register(UINib(nibName: "MyOrdersViewCell", bundle: nil), forCellReuseIdentifier: "myOrderCell")
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        ordersViewModel.orders.drive(tableView.rx.items(
            cellIdentifier: "myOrderCell", cellType: MyOrdersViewCell.self)){index , element ,cell in
                cell.setupCell(order: element)
            }.disposed(by: disposeBag)
    }
}
