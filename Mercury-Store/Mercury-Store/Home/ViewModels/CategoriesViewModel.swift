//
//  CategoriesViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 22/05/2022.
//

import RxSwift
import RxCocoa

protocol CategoriesViewModelType {
    var categories: Driver<[CategoryDataItem]> { get }
    func goToFilteredProductScreen(with id: Int)
}

final class CategoriesViewModel: CategoriesViewModelType {
    private weak var homeNavigationFlow: HomeFlowNavigation?
    private var categoriesSubject: PublishSubject = PublishSubject<[CategoryDataItem]>()
    var categories: Driver<[CategoryDataItem]>
    
    private var categoriesArray: [CategoryDataItem] = [
        CategoryDataItem(id: 395961565442, name: "Home", imageName: "home", colorHex: "#FEDDE1"),
        CategoryDataItem(id: 397089505538, name: "Men", imageName: "Men", colorHex: "#642CA9"),
        CategoryDataItem(id: 397089538306, name: "Women", imageName: "Women", colorHex: "#FF36AB"),
        CategoryDataItem(id: 397089571074, name: "Kids", imageName: "Kids", colorHex: "#FF74D4"),
        CategoryDataItem(id: 397089603842, name: "Sale", imageName: "Sale", colorHex: "#FEB&DE"),
    ]
    
    init(with homeFlowNavigation: HomeFlowNavigation) {
        categories = categoriesSubject.asDriver(onErrorJustReturn: [])
        self.homeNavigationFlow = homeFlowNavigation
    }
    
    func getCategories() {
        categoriesSubject.onNext(categoriesArray)
    }
    
    func goToFilteredProductScreen(with id: Int) {
        homeNavigationFlow?.goToFilteredProduct(with: id)
    }
}
