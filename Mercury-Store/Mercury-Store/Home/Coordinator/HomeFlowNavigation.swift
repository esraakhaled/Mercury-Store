//
//  HomeFlowNavigation.swift
//  Mercury-Store
//
//  Created by mac hub on 03/06/2022.
//

import Foundation

protocol HomeFlowNavigation: AnyObject {
    func goToFilteredProduct(with id: Int)
    func goToBrandDetails(with brandItem: SmartCollectionElement)
    func goToSearchViewController()
    func viewWillAppearNavBarReturn()
}
