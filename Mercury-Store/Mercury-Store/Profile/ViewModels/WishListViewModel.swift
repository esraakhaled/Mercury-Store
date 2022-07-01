//
//  WishListViewModel.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 04/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol WishListViewModelType {
    var products: Driver<[SavedProductItem]> { get}
    var error: Driver<String?> { get }
    var emptyView: Driver<Bool> { get }
    func getFavouriteItems()
    func updateItem(item:SavedProductItem)
    func deleteItem(item:SavedProductItem)
    func isFavouriteItem(productID:Int)->Bool
    func modifyOrderInFavApi()
}

class WishListViewModel:WishListViewModelType{

    private let emptyViewSubject = BehaviorRelay<Bool>(value: true)
    private let productSubject = BehaviorRelay<[SavedProductItem]>(value: [])
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    private let ordersProvider: OrdersProvider
    private let customerProvider: CustomerProvider
    private let coreDataModel:CoreDataModel
    private let disposeBag = DisposeBag()
    private let favOrderSubject = PublishSubject<DraftOrderResponseTest>()
    private let editCustomerSubject = PublishSubject<RegisterResponse>()
    
    var emptyView: Driver<Bool> {
        return emptyViewSubject
            .asDriver(onErrorJustReturn: true)
    }
    var products: Driver<[SavedProductItem]>
    var error: Driver<String?>

    init(ordersProvider: OrdersProvider = OrdersClient(),
        customerProvider: CustomerProvider = CustomerClient()
    ){
        self.ordersProvider = ordersProvider
        self.customerProvider = customerProvider
        coreDataModel = CoreDataModel.coreDataInstatnce
        products = productSubject.asDriver(onErrorJustReturn: [])
        error = errorSubject.asDriver(onErrorJustReturn: "Somthing went wrong")
    }
    func getFavouriteItems() {
        self.productSubject.accept([])
        self.errorSubject.accept(nil)
        let items = self.coreDataModel.getItemsByUserID()
        if(items.0.isEmpty) {
            self.emptyViewSubject.accept(false)
        }else {
            if(items.1 == nil){
                self.productSubject.accept(items.0)
                self.errorSubject.accept(nil)
                self.emptyViewSubject.accept(true)
            }else {
                self.errorSubject.accept(items.1?.localizedDescription)
            }
        }
        
    }
    
    func updateItem(item: SavedProductItem) {
        let state = self.coreDataModel.update(updateitem: item)
        if (state.1) {
            getFavouriteItems()
            self.errorSubject.accept(nil)
        }
        else {
            self.errorSubject.accept("Somthing went wrong")
            
        }
    }
    
    func deleteItem(item: SavedProductItem) {
        let state = self.coreDataModel.deleteFavouriteProduct(productID: Int(truncating: NSDecimalNumber(decimal: item.productID)))
        if (state) {
            self.errorSubject.accept(nil)
            getFavouriteItems()
        }
        else {
            self.errorSubject.accept("Somthing went wrong")
        }
    }
    func isFavouriteItem(productID:Int)->Bool{
        return self.coreDataModel.isProductFavourite(id: productID)
    }
    
    // MARK: - API Section
    //
    
    func modifyOrderInFavApi() {
        let user = getUserFromUserDefaults()
        if(user != nil && user!.favouriteId != 0) {
            let savedItemsInFav = self.coreDataModel.getItemsByUserID().0
            if(!savedItemsInFav.isEmpty) {
                let putDraftOrder = PutOrderRequest(draftOrder: ModifyDraftOrderRequest(dratOrderId: user!.favouriteId, lineItems: savedItemsInFav.map { item in
                    return LineItemDraft(quantity: 1, variantID: item.variantId, properties: [PropertyDraft(imageName: item.productImage, inventoryQuantity: "\(item.inventoryQuantity)")])
                }))
                self.ordersProvider.modifyExistingOrder(with: user!.favouriteId, and: putDraftOrder)
                    .subscribe(onNext: {[weak self] result in
                        guard let `self` = self else {fatalError()}
                        self.favOrderSubject.onNext(result)
                    }).disposed(by: disposeBag)
            }else {
                self.ordersProvider.deleteExistingOrder(with: user!.favouriteId)
                    .subscribe { _ in
                        
                    }.disposed(by: disposeBag)
                self.modifyCustomerData(draftOrderId: 0)
            }
        }
    }
    
    private func modifyCustomerData(draftOrderId: Int) {
        let user = getUserFromUserDefaults()
        self.customerProvider.editCustomer(id: user!.id , editCustomer: EditCustomer(customer: EditCustomerItem(id: user!.id, email: user!.email, firstName: user!.username, password: user!.password, cartId: "\(user!.cartId)", favouriteId: "\(draftOrderId)")))
            .subscribe(onNext: {[weak self] userResult in
                guard let `self` = self else {fatalError()}
                self.editCustomerSubject.onNext(userResult)
                let newUser = User(id: user!.id , email: user!.email, username: user!.username, isLoggedIn: true, isDiscount: false, password: user!.password, cartId: user!.cartId, favouriteId: Int(userResult.customer.cartId) ?? 0)
                try! UserDefaults.standard.setObject(newUser, forKey: "user")
            }).disposed(by: self.disposeBag)
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
