//
//  CategoriesNavigationFlow.swift
//  Mercury-Store
//
//  Created by mac hub on 03/06/2022.
//

import Foundation

protocol CategoriesNavigationFlow: AnyObject {
    func gotToProductScreen(with id: Int, type: String)
    func goToSearchScreen()
}
