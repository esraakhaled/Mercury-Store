
//
//  ProductSearchViewModel.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 04/06/2022.
//

import Foundation
import RxCocoa
import RxSwift


struct SearchOutput {
    let filteredItems: Observable<[SearchSection]>
}

final class ProductSearchViewModel {
    private weak var searchFlowNavigation : SearchFlowNavigation?
    private let provider: SearchProvider
    
    private let disposeBag = DisposeBag()
    private let searchBarBehavior = BehaviorSubject<String?>(value: "")
    private let sortBehavior = BehaviorSubject<String> (value: "")
    private let productListSubject = PublishSubject<[Product]>()
    private let isLoadingSubject = BehaviorRelay<Bool> (value: false)
    
    private let errorSubject = BehaviorRelay<Bool>(value: true)
    var error: Driver<Bool> {
        return errorSubject
            .asDriver(onErrorJustReturn: true)
    }
    
    var searchByName: AnyObserver<String?> { searchBarBehavior.asObserver()}
    var isLoadingData: Driver<Bool> {isLoadingSubject.asDriver(onErrorJustReturn: false)}
    let value = BehaviorRelay<Int>(value:0)
    let sortArray = ["Price: High to Low" , "Price: Low to High", "Sort from A to Z"]
    
    init(provider: SearchProvider = SearchClient(),searchFlowNavigation : SearchFlowNavigation) {
        self.provider = provider
        self.searchFlowNavigation = searchFlowNavigation
    }
    
    
    func bind() -> SearchOutput {
        let search = Observable.merge(
            filterArrayBasedOnSearch(),
            filterArrayBasedOnSlider(),
            filterArrayBasedAlphabetically()
        )
        return SearchOutput(filteredItems: search)
    }
    
    func filterArrayBasedOnSearch() -> Observable<[SearchSection]> {
        Observable.combineLatest(
            searchBarBehavior
                .map { $0 ?? "" }
                .startWith("")
                .distinctUntilChanged()
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance),
            productListSubject
        )
        .map { searchValue, products in
            searchValue.isEmpty ? products : products.filter { $0.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(searchValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) }
        }.map { values in
            if(values.isEmpty) {
                self.errorSubject.accept(false)
                return []
            } else {
                self.errorSubject.accept(true)
                return [SearchSection(values)]
            }
            
        }
    }
    
    func filterArrayBasedOnSlider() -> Observable<[SearchSection]> {
        return Observable.combineLatest(
            value
                .map{ $0 }
                .startWith(0)
                .throttle(.microseconds(500), scheduler: MainScheduler.instance),
            productListSubject
        )
        .map { searchValue, products in
            searchValue == 0 ? products : products.filter {
                Double($0.variants[0].price) == Double(searchValue)
            }
        }.map { values in
            [SearchSection(values)]
        }
    }
    
    func acceptTitle(_ title: String) {
        self.sortBehavior.onNext(title)
    }
    func filterArrayBasedAlphabetically() -> Observable<[SearchSection]> {
        return Observable.combineLatest(
            sortBehavior
                .map{$0 }
                .startWith(""),
            productListSubject
        )
        .map { searchValue, products in
            if(searchValue == self.sortArray[0]) {
                
                return products.sorted(by: {Double($0.variants[0].price) ?? 0 > Double($1.variants[0].price) ?? 0})
            }else if (searchValue == self.sortArray[1]) {
                 return products.sorted(by: {Double($0.variants[0].price) ?? 0 < Double($1.variants[0].price) ?? 0})
            }else if (searchValue == self.sortArray[2]) {
                return products.sorted(by: {$0.title.lowercased() < $1.title.lowercased()})
            }
            return products
        }.map { values in
            [SearchSection(values)]
        }
    }
    
    func fetchData() {
        self.isLoadingSubject.accept(true)
        self.provider.getProductsList()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (result) in
                self?.productListSubject.onNext(result.products)
                self?.isLoadingSubject.accept(false)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func goToProductDetailFromSearch(with item:Product) {
        searchFlowNavigation?.goToProductDetailFromSearch(with: item)
    }
}
