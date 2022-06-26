//
//  HomeClient.swift
//  Mercury-Store
//
//  Created by mac hub on 23/05/2022.
//

import RxSwift

protocol BrandsProvider: AnyObject {
    func getBrandsCollection() -> Observable<SmartCollection>
}

protocol ProductsForBrandProvider: AnyObject {
    func getProductsForBrand(with id: Int) -> Observable<ProductsCategory>
}

protocol ProductsProvider: AnyObject {
    func getAllProducts() -> Observable<ProductsCategory>
}

protocol DraftOrderProvider: AnyObject {
    func getDraftOrder(with id: Int) -> Observable<DraftOrderResponseTest>
}

class HomeScreenClient: BrandsProvider {
    func getBrandsCollection() -> Observable<SmartCollection> {
        NetworkService().execute(HomeScreenAPIs.getBrands)
    }
}

extension HomeScreenClient: ProductsForBrandProvider {
    func getProductsForBrand(with id: Int) -> Observable<ProductsCategory> {
        NetworkService().execute(HomeScreenAPIs.getProductsForBrand(id))
    }
}

extension HomeScreenClient: ProductsProvider {
    func getAllProducts() -> Observable<ProductsCategory> {
        NetworkService().execute(HomeScreenAPIs.getAllProducts)
    }
}

extension HomeScreenClient: DraftOrderProvider {
    func getDraftOrder(with id: Int) -> Observable<DraftOrderResponseTest> {
        NetworkService().execute(HomeScreenAPIs.getDraftOrders(id))
    }
}
