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
        
        CategoryDataItem(id: 395963597058, name: "Men", imageName: "Men", colorHex: "#642CA9"),
        CategoryDataItem(id: 395964121346, name: "Men-1", imageName: "Men", colorHex: "#642CA9"),
        CategoryDataItem(id: 395964875010, name: "Men-2", imageName: "Men", colorHex: "#642CA9"),
        CategoryDataItem(id: 395965399298, name: "Men-3", imageName: "Men", colorHex: "#642CA9"),
        
        CategoryDataItem(id: 395963629826, name: "Women", imageName: "Women", colorHex: "#FF36AB"),
        CategoryDataItem(id: 395964154114, name: "Women-1", imageName: "Women", colorHex: "#FF36AB"),
        CategoryDataItem(id: 395964907778, name: "Women-2", imageName: "Women", colorHex: "#FF36AB"),
        CategoryDataItem(id: 395965432066, name: "Women-3", imageName: "Women", colorHex: "#FF36AB"),
        
        
        CategoryDataItem(id: 395963662594, name: "Kids", imageName: "Kids", colorHex: "#FF74D4"),
        CategoryDataItem(id: 395964186882, name: "Kids-1", imageName: "Kids", colorHex: "#FF74D4"),
        CategoryDataItem(id: 395964940546, name: "Kids-2", imageName: "Kids", colorHex: "#FF74D4"),
        CategoryDataItem(id: 395965464834, name: "Kids-3", imageName: "Kids", colorHex: "#FF74D4"),
        
        
        CategoryDataItem(id: 395963695362, name: "Sale", imageName: "Sale", colorHex: "#FEB&DE"),
        CategoryDataItem(id: 395964219650, name: "Sale-1", imageName: "Sale", colorHex: "#FEB&DE"),
        CategoryDataItem(id: 395964973314, name: "Sale-2", imageName: "Sale", colorHex: "#FEB&DE"),
        CategoryDataItem(id: 395965497602, name: "Sale-3", imageName: "Sale", colorHex: "#FEB&DE"),
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
