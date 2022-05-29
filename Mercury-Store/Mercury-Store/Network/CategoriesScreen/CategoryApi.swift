//
//  CategoryApi.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 27/05/2022.
//

import Foundation
import Alamofire

enum CategoryScreenAPIs: URLRequestBuilder {
    case getCategories
    case getProducts
}

extension CategoryScreenAPIs {
    var path: String {
        switch self {
        case .getCategories:
            return Constants.Pathes.Categories.brandsList
        case .getProducts:
            return Constants.Pathes.ProductsCategory.productCategoriesList(categoryID: 395727732965)
        }
    }
}

extension CategoryScreenAPIs {
    var parameters: Parameters? {
        switch self {
        case .getCategories:
            return [:]
        case .getProducts:
            return ["categoryID":395727732965]
        }
    }
}

extension CategoryScreenAPIs {
    var method: HTTPMethod {
        switch self {
        case .getCategories:
            return HTTPMethod.get
        case .getProducts:
            return HTTPMethod.get
        }
    }
}
