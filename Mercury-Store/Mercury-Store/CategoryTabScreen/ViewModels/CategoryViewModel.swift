//
//  CategoryViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//
import Foundation
import RxSwift
import RxCocoa

protocol CategoriesScreenViewModelType {
    var isLoading: Driver<Bool> { get }
    var categories: Driver<[CustomCollection]> { get}
    var error: Driver<String?> { get }
    func goToSearchViewController()
}


final class CategoriesScreenViewModel: CategoriesScreenViewModelType {
    private weak var categoriesNavigationFlow:CategoriesNavigationFlow?
    
    private let categoryProvider: CategoriesProvider = CategoriesScreenAPI()
    private let disposeBag = DisposeBag()
    
    private let categorySubject = BehaviorRelay<[CustomCollection]>(value: [])
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    
    var isLoading: Driver<Bool>
    
    var categories: Driver<[CustomCollection]>
    
    var error: Driver<String?>
    var categoryDetails:CategoryProductsScreenViewModelType
    
    init(with categoryFlow: CategoriesNavigationFlow) {
        self.categoriesNavigationFlow = categoryFlow
        categories = categorySubject.asDriver(onErrorJustReturn: [])
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: "Somthing went wrong")
        categoryDetails = SubCategoriesViewModel(categoryID: 0)
        self.fetchData()
    }
    private func fetchData() {
        self.categorySubject.accept([])
        self.isLoadingSubject.accept(true)
        self.errorSubject.accept(nil)
        self.categoryProvider.getCategoriesCollection()
            .observe(on: MainScheduler.asyncInstance)
                    .subscribe {[weak self] (result) in
                        self?.isLoadingSubject.accept(false)
                        self?.categorySubject.accept(result.customCollections)
                        self?.categoryDetails.categoryID = result.customCollections[0].id
                    } onError: {[weak self] (error) in
                        self?.isLoadingSubject.accept(false)
                        self?.errorSubject.accept(error.localizedDescription)
                    }.disposed(by: disposeBag)
    }
    func goToSearchViewController() {
        self.categoriesNavigationFlow?.goToSearchScreen()
    }
    
}

extension CategoriesScreenViewModel {
    func gotToProductScreen(with id: Int, type: String) {
        self.categoriesNavigationFlow?.gotToProductScreen(with: id, type: type)
    }
}
