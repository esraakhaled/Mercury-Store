//
//  BrandDetailsViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 03/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol BrandDetailsViewModelType: AnyObject {
    var item: SmartCollectionElement { get }
    var isLoading: Driver<Bool> { get }
    var productsForBrand: Driver<[Product]> { get }
    var error: Driver<String?> { get }
    func fetchData()
    func goToProductDetails(with product: Product)
}

protocol BrandDetailsNavigationFlow: AnyObject {
    func goToProductDetails(with product: Product)
}

final class BrandDetailsViewModel: BrandDetailsViewModelType {
    
    private weak var brandDetailsNavigationFlow: BrandDetailsNavigationFlow?
    private let productsForBrandProvider: ProductsForBrandProvider
    private let productsForBrandSubject = BehaviorRelay<[Product]>(value: [])
    private let isLoadingSubject = BehaviorRelay<Bool> (value: false)
    
    private let errorSubject = BehaviorRelay<String?> (value: nil)
    private let disposeBag = DisposeBag()
    
    var item: SmartCollectionElement
    
    var isLoading: Driver<Bool>
    
    var productsForBrand: Driver<[Product]>
    
    var error: Driver<String?>
    
    
    init(with model: SmartCollectionElement, productsForBrandProvider: ProductsForBrandProvider,brandDetailsNavigationFlow: BrandDetailsNavigationFlow) {
        productsForBrand = productsForBrandSubject.asDriver(onErrorJustReturn: [])
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: "Something went wrong")
        self.item = model
        self.productsForBrandProvider = productsForBrandProvider
        self.brandDetailsNavigationFlow = brandDetailsNavigationFlow
    }
    
    func fetchData() {
        self.productsForBrandSubject.accept([])
        self.isLoadingSubject.accept(true)
        self.errorSubject.accept(nil)
        
        self.productsForBrandProvider.getProductsForBrand(with: item.id)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (result) in
                self?.isLoadingSubject.accept(false)
                self?.productsForBrandSubject.accept(result.products)
            } onError: {[weak self] (error) in
                self?.isLoadingSubject.accept(false)
                self?.errorSubject.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

extension BrandDetailsViewModel {
    func goToProductDetails(with product: Product) {
        self.brandDetailsNavigationFlow?.goToProductDetails(with: product)
    }
}


