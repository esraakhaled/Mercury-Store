//
//  FilteredProductsNavigationFlow.swift
//  Mercury-Store
//
//  Created by mac hub on 03/06/2022.
//

import Foundation

protocol FilteredProductsNavigationFlow: AnyObject {
    func goToProductDetail(with product: Product)
    func goToFilteredProductScreen()
    func goToSearchScreen()
}
