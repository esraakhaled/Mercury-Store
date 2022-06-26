//
//  FilteredProducts.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 03/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol FilteredProductsViewModelType {
    var isLoading: Driver<Bool> { get }
    var products: Driver<[Product]> { get}
    var error: Driver<String?> { get }
    func goToProductDetail(with product: Product)
    func goToFilteredProductScreen()
    func isProductFavourite(id:Int) -> Bool
    func goToSearchScreen()
}

final class FilteredProductsViewModel: FilteredProductsViewModelType {
    private weak var filteredProductsNavigationFlow: FilteredProductsNavigationFlow?
    private let categoryProvider: CategoriesProvider = CategoriesScreenAPI()
    private let disposeBag = DisposeBag()
    
    private let categorySubject = BehaviorRelay<[Product]>(value: [])
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    
    private let categoryID:Int
    private let productType:String
    
    var isLoading: Driver<Bool>
    
    var products: Driver<[Product]>
    
    var error: Driver<String?>
    
    init(categoryID:Int, productType:String, filteredProductsNavigationFlow: FilteredProductsNavigationFlow) {
        products = categorySubject.asDriver(onErrorJustReturn: [])
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: "Somthing went wrong")
        self.categoryID = categoryID
        self.productType = productType
        self.filteredProductsNavigationFlow = filteredProductsNavigationFlow
        self.fetchData()
    }
    func goToSearchScreen() {
        filteredProductsNavigationFlow?.goToSearchScreen()
    }
    private func fetchData() {
        self.categorySubject.accept([])
        self.isLoadingSubject.accept(true)
        self.errorSubject.accept(nil)
        self.categoryProvider.getFiltredCollectionProductsByType(collectionID: categoryID, productType: productType)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (result) in
                self?.isLoadingSubject.accept(false)
                self?.categorySubject.accept(result.products)
            } onError: {[weak self] (error) in
                self?.isLoadingSubject.accept(false)
                self?.errorSubject.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func isProductFavourite(id:Int) -> Bool{
        if let user =  getCurrentUserId(){
            return CoreDataModel.coreDataInstatnce.isProductFavourite(id: id)
        }else {
            return false
        }
    }
    
}

extension FilteredProductsViewModel {
    func goToProductDetail(with product: Product) {
        self.filteredProductsNavigationFlow?.goToProductDetail(with: product)
    }
    
    func goToFilteredProductScreen() {
        self.filteredProductsNavigationFlow?.goToFilteredProductScreen()
    }
}
