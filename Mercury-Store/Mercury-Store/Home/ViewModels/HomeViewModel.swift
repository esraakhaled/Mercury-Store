//
//  HomeViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    
    private weak var homeNavigation: HomeFlowNavigation!
    private let allProductsProvider: ProductsProvider
    private let draftOrderProvider: DraftOrderProvider
    private let disposeBag = DisposeBag()
    private let productsSubject = PublishSubject<[Product]>()
    private let isLoadingSubject = BehaviorRelay<Bool> (value: false)
    private let fetchedItemsFromCoreData = CoreDataModel.coreDataInstatnce.getItems(productState: productStates.cart).0
    private let fetchedItemsFromCoreDataFav = CoreDataModel.coreDataInstatnce.getItems(productState: productStates.favourite).0
    
    var isLoading: Driver<Bool>
    let items = BehaviorSubject<[HomeTableViewSection]>(value: [
        .LogoSection(items: [
            .LogoTableViewItem
        ]),
        .CategoriesSection(items: [
            .CategoriesCell
        ]),
        .BannerSection(items: [
            .BannerTableViewItem
        ]),
        
            .BrandsSection(items: [
                .BrandsCell
            ])
    ])
    
    init(with homeNavigationFlow: HomeFlowNavigation, allProductsProvider: ProductsProvider = HomeScreenClient(),draftOrderProvider: DraftOrderProvider = HomeScreenClient()) {
        self.homeNavigation = homeNavigationFlow
        self.allProductsProvider = allProductsProvider
        self.draftOrderProvider = draftOrderProvider
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
    }
    
    func goToSearchViewController() {
        homeNavigation.goToSearchViewController()
    }
    
    func viewWillAppearNavReturn() {
        homeNavigation.viewWillAppearNavBarReturn()
    }
    
    func getDraftOrderById() {
        let user = getUserFromUserDefaults()
        if (user != nil) {
            if(user!.cartId != 0) {
                self.isLoadingSubject.accept(true)
                self.draftOrderProvider.getDraftOrder(with: user!.cartId)
                    .subscribe(onNext:  {[weak self] result in
                        guard let `self` = self else {fatalError()}
                        if(self.fetchedItemsFromCoreData.isEmpty) {
                            for item in result.draftOrder.lineItems {
                                let newSaved = SavedProductItem(inventoryQuantity: Int(item.properties[0].inventoryQuantity) ?? 0, variantId: item.variantID, productID: Decimal(item.productID), productTitle: item.title, productImage: item.properties[0].imageName, productPrice: Double(item.price)!, productQTY: item.quantity, producrState: 1)
                                let _ = CoreDataModel.coreDataInstatnce.insertCartProduct(product: newSaved)
                                CoreDataModel.coreDataInstatnce.observeProductCount()
                            }
                        }
                    }).disposed(by: disposeBag)
            }
        }
        
    }
    
    func getDraftOrderFav() {
        let user = getUserFromUserDefaults()
        if (user != nil) {
            if(user!.favouriteId != 0) {
                self.isLoadingSubject.accept(true)
                self.draftOrderProvider.getDraftOrder(with: user!.favouriteId)
                    .subscribe(onNext:  {[weak self] result in
                        guard let `self` = self else {fatalError()}
                        if(self.fetchedItemsFromCoreDataFav.isEmpty) {
                            for item in result.draftOrder.lineItems {
                                let newSaved = SavedProductItem(inventoryQuantity: Int(item.properties[0].inventoryQuantity) ?? 0, variantId: item.variantID, productID: Decimal(item.productID), productTitle: item.title, productImage: item.properties[0].imageName, productPrice: Double(item.price)!, productQTY: item.quantity, producrState: 0)
                                let _ = CoreDataModel.coreDataInstatnce.insertFavouriteProduct(product: newSaved)
                            }
                        }
                    }).disposed(by: disposeBag)
            }
        }
    }
    
    private func getUserFromUserDefaults() -> User? {
        do {
            return try UserDefaults.standard.getObject(forKey: "user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

