//
//  ProductDetailsViewModel.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 01/06/2022.
//

/*import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol ProductsDetailsViewModelType {
    var isLoading: Driver<Bool> { get }
    var variants: Driver<Product> { get}
    var error: Driver<String?> { get }
}

final class ProductsDetailsViewModel: ProductsDetailsViewModelType {
    var isLoading: Driver<Bool>
    
    var variants: Driver<Product>
    
    var error: Driver<String?>
    
    private let categoryProvider: CategoriesProvider = CategoriesScreenAPI()
    private let disposeBag = DisposeBag()
    
    private let productDetailsSubject = PublishSubject<Product>()
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    
    
   init(productID:Int) {
       // variants = productDetailsSubject.asDriver()
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: "Somthing went wrong")
        //self.fetchData(productID: productID)
    }
    private func fetchData(productID:Int) {
       // self.productDetailsSubject.accept()
        self.isLoadingSubject.accept(true)
        self.errorSubject.accept(nil)
        self.categoryProvider.getCategoryProductsDetails(productID: productID)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (result) in
                self?.isLoadingSubject.accept(false)
            //    self?.productDetailsSubject.accept(result.)
                print(result.variants.count)
            } onError: {[weak self] (error) in
                self?.isLoadingSubject.accept(false)
                self?.errorSubject.accept(error.localizedDescription)
            }.disposed(by: disposeBag)

    }
    
    
}

*/
