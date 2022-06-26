//
//  PriceRules.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 11/06/2022.
//

import Foundation
import Alamofire
enum PricesRules: URLRequestBuilder {
    case getPricesRules
    case getCoupon(Int)
}
extension PricesRules {
    var path: String {
        switch self {
        case .getPricesRules:
            return Constants.Paths.PricesRule.pricesRules
        case .getCoupon(let id):
            return Constants.Paths.PricesRule.getCoupon(id: id)
        }
    }
}

extension PricesRules {
    var parameters: Parameters? {
        switch self {
        case .getPricesRules:
            return [:]
        case .getCoupon(let itemID):
            return [:]
        }
    }
}

extension PricesRules {
    var method: HTTPMethod {
        switch self {
        case .getPricesRules:
            return HTTPMethod.get
        case .getCoupon(_):
            return HTTPMethod.get
        }
    }
}

