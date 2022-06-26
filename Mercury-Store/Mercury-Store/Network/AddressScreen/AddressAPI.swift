//
//  AddressApI.swift
//  Mercury-Store
//
//  Created by mac hub on 13/06/2022.
//

import Foundation
import Alamofire

enum AddressAPI: URLRequestBuilder {
    case postAddress(Int,AddressRequest)
    case getAddress(Int)
    case putAddress(Int,Int,AddressRequestPut)
    case deleteAddress(Int,Int)
    
}

extension AddressAPI {
    var path: String {
        switch self {
        case .postAddress(let id, _):
            return "/customers/\(id)/addresses.json"
        case .getAddress(let id):
            return  "/customers/\(id)/addresses.json"
        case .putAddress(let customerId, let addressId, _):
            return "/customers/\(customerId)/addresses/\(addressId).json"
        case .deleteAddress(let customerId, let addressId):
            return "/customers/\(customerId)/addresses/\(addressId).json"
        }
    }
}

extension AddressAPI {
    var parameters: Parameters? {
        switch self {
        case .postAddress(_, let addressRequest):
            return try! addressRequest.asDictionary()
        case .putAddress(_, _, let addressRequestPut):
            return try! addressRequestPut.asDictionary()
        case .getAddress:
            return [:]
        case .deleteAddress(_, _):
            return [:]
        }
    }
}

extension AddressAPI {
    var method: HTTPMethod {
        switch self {
        case .postAddress:
            return .post
        case .getAddress:
            return .get
        case .putAddress:
            return .put
        case .deleteAddress:
            return .delete
        }
    }
}
