//
//  CategoriesClient.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 27/05/2022.
//
import RxSwift

protocol CategoriesProvider: AnyObject {
    func getCategoriesCollection() -> Observable<MainCstegories>
    func getCategoryProductsCollection(collectionID:Int) -> Observable<ProductsCategory>
    func getFiltredCollectionProductsByType(collectionID:Int ,productType:String) -> Observable<ProductsCategory>
    
}

class CategoriesScreenAPI: CategoriesProvider {
    func getCategoryProductsCollection(collectionID:Int) -> Observable<ProductsCategory> {
        NetworkService().execute(CategoryScreenAPIs.getProducts(collectionID))
    }
    
    func getCategoriesCollection() -> Observable<MainCstegories> {
        NetworkService().execute(CategoryScreenAPIs.getCategories)
    }
    
    func getFiltredCollectionProductsByType(collectionID:Int ,productType:String) -> Observable<ProductsCategory>{
        NetworkService().execute(CategoryScreenAPIs.getFilteredProduct(collectionID, productType))
    }
}
