//
//  OrdersAPI.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 10/06/2022.
//

import Foundation
import Alamofire

enum OrdersAPI: URLRequestBuilder {
    case getCustomerOrders(Int)
    case postDraftOrder(DraftOrdersRequest)
    case modifyExistingOrder(Int, PutOrderRequest)
    case deleteDraftOrder(Int)
    case postOrder(PostOrderRequest)
}
extension OrdersAPI {
    var path: String {
        switch self {
        case .getCustomerOrders(let id):
            return Constants.Paths.Customers.customerOrders + "/\(id)/orders.json"
        case .postDraftOrder:
            return Constants.Paths.Order.postDraftOrder
        case .modifyExistingOrder(let id, _):
            return "/draft_orders/\(id).json"
        case .deleteDraftOrder(let id):
            return Constants.Paths.Order.modifyExistingOrder + "/\(id).json"
        case .postOrder:
            return Constants.Paths.Order.postOrder
        }
    }
}

extension OrdersAPI {
    var parameters: Parameters? {
        switch self {
        case .getCustomerOrders:
            return [:]
        case .postDraftOrder(let order):
            return try! order.asDictionary()
        case .modifyExistingOrder(_, let order):
            return try! order.asDictionary()
        case .deleteDraftOrder:
            return [:]
        case .postOrder(let order):
            return try! order.asDictionary()
        }
    }
}

extension OrdersAPI {
    var method: HTTPMethod {
        switch self {
        case .getCustomerOrders:
            return .get
        case .postDraftOrder:
            return HTTPMethod.post
        case .modifyExistingOrder:
            return .put
        case .deleteDraftOrder:
            return .delete
        case .postOrder(_):
            return .post
        }
    }
}
