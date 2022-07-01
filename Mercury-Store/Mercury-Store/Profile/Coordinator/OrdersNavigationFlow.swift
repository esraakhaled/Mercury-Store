//
//  OrdersNavigationFlow.swift
//  Mercury-Store
//
//  Created by mac hub on 29/06/2022.
//

import Foundation

protocol OrdersNavigationFlow: AnyObject {
    func goToOrderDetails(with order: CustomerOrders)
}
