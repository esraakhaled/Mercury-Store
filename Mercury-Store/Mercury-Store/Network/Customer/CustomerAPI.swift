//
//  CustomerAPI.swift
//  Mercury-Store
//
//  Created by mac hub on 08/06/2022.
//

import Alamofire

enum CustomerAPI: URLRequestBuilder {
    case postCustomer(Customer)
    case getCustomer(Int)
    case editCustomer(Int, EditCustomer)
    case getCustomerByEmail(String)
}

extension CustomerAPI {
    var path: String {
        switch self {
        case .postCustomer:
            return Constants.Paths.Customers.customer
        case .getCustomer(let id):
            return "/customers/\(id).json"
        case .editCustomer(let id, _):
            return "/customers/\(id).json"
        case .getCustomerByEmail:
            return Constants.Paths.Customers.customerSearch
        }
    }
}

extension CustomerAPI {
    var parameters: Parameters? {
        switch self {
        case .postCustomer(let customer):
            return try! customer.asDictionary()
        case .getCustomer:
            return [:]
        case .editCustomer(_ , let editCustomer):
            return try! editCustomer.asDictionary()
        case .getCustomerByEmail(let email):
            
            return ["query": "email:\(email)"]
        }
    }
}

extension CustomerAPI {
    
    var method: HTTPMethod {
        switch self {
        case .postCustomer:
            return .post
        case .getCustomer:
            return .get
        case .editCustomer:
            return .put
        case .getCustomerByEmail:
            return .get
        }
    }
}
