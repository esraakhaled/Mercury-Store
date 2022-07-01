//
//  MyOrdersViewCell.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 22/05/2022.
//

import UIKit

class MyOrdersViewCell: UITableViewCell {
    // MARK: - IBOutlets
    //
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var price: UILabel!
    static func reuseIdentifier() -> String {
        return "myOrderCell"
    }
    // MARK: - Life cycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func setupCell(order: CustomerOrders){
        viewContainer.bounds = CGRect(x: 8, y: 8, width: self.frame.width-8 , height: self.frame.height-8 )
        createdAt.text = "\(order.name) \(order.createdAt.formatted(.dateTime))"
        price.text = "Order total price: \(CurrencyHelper().checkCurrentCurrency("\(order.totalPrice)"))"
        paid.text = "address: \(order.shippingAddress?.city  ?? "") - \(order.shippingAddress?.province ?? "") "
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
