//
//  HomeScreenAPIs.swift
//  Mercury-Store
//
//  Created by mac hub on 23/05/2022.
//

import Alamofire

enum HomeScreenAPIs: URLRequestBuilder {
    case getBrands
    case getProductsForBrand(Int)
    case getAllProducts
    case getDraftOrders(Int)
}

extension HomeScreenAPIs {
    var path: String {
        switch self {
        case .getBrands:
            return Constants.Paths.Brands.brandsList
        case .getProductsForBrand, .getAllProducts:
            return Constants.Paths.Products.productList
        case .getDraftOrders(let id):
            return "/draft_orders/\(id).json"
        }
    }
}

extension HomeScreenAPIs {
    var parameters: Parameters? {
        switch self {
        case .getBrands, .getDraftOrders, .getAllProducts:
            return [:]
        case .getProductsForBrand(let id):
            return ["collection_id" : id]
        }
    }
}

extension HomeScreenAPIs {
    var method: HTTPMethod {
        switch self {
        case .getBrands, .getDraftOrders, .getProductsForBrand, .getAllProducts:
            return HTTPMethod.get
        }
    }
}

