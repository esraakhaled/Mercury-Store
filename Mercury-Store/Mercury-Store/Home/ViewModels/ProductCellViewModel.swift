//
//  ProductCellViewModel.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 07/06/2022.
//
import Foundation
import RxSwift
import RxCocoa

protocol ProductCellViewModelType{
    func toggleFavourite(product:SavedProductItem)->Bool
    func getFavouriteState(productID:Int)->Bool
    var userID:Int?{get}
    func modifyOrderInWishIfFavIdIsNil(_ product: Product, variant: Variant)
}

class ProductCellViewModel:ProductCellViewModelType{
    private let cartOrderSubject = PublishSubject<DraftOrderResponseTest>()
    private let userDefaults: UserDefaults
    private let ordersProvider: OrdersProvider
    private let disposeBag = DisposeBag()
    private let customerProvider: CustomerProvider
    private let editCustomerSubject = PublishSubject<RegisterResponse>()
    private let favOrderSubject = PublishSubject<DraftOrderResponseTest>()
    private let coreDataModel:CoreDataModel
    
    
    init(ordersProvider: OrdersProvider = OrdersClient(),
         userDefaults: UserDefaults = UserDefaults.standard, customerProvider: CustomerProvider = CustomerClient()) {
        self.ordersProvider = ordersProvider
        self.userDefaults = userDefaults
        self.customerProvider = customerProvider
        coreDataModel = CoreDataModel.coreDataInstatnce
    }
    var userID: Int?{
        getCurrentUserId()
    }
    func toggleFavourite(product:SavedProductItem)->Bool{
        if getCurrentUserId() != nil{
            return CoreDataModel.coreDataInstatnce.toggleFavourite(product: product)
        }else {
            return false
        }
        
    }
    
    func getFavouriteState(productID:Int) -> Bool{
        if getCurrentUserId() != nil{
            return CoreDataModel.coreDataInstatnce.isProductFavourite(id: productID)
        }else {
            return false
        }
    }
    
    // MARK: - API Section
    //
    func modifyOrderInWishIfFavIdIsNil(_ product: Product, variant: Variant) {
        let user = getUserFromUserDefaults()
        if(user != nil) {
            if(user!.favouriteId == 0) {
                self.postOrderIntoFavorite(product, variant: variant)
            }else {
                self.putDraftOrder()
            }
        }
    }
    
    private func postOrderIntoFavorite(_ product: Product, variant: Variant) {
        let user = getUserFromUserDefaults()
        if (user != nil) {
            let newLineItemDraft = LineItemDraft(quantity: 1, variantID: variant.id, properties: [PropertyDraft(imageName: product.image.src, inventoryQuantity: "\(variant.inventoryQuantity)")])
            let newOrderRequest = DraftOrdersRequest(draftOrder: DraftOrderItem(lineItems: [newLineItemDraft], customer: CustomerId(id: user!.id), useCustomerDefaultAddress: true))
            self.ordersProvider.postDraftOrder(order: newOrderRequest)
                .subscribe(onNext: {[weak self] result in
                    guard let `self` = self else {fatalError()}
                    self.cartOrderSubject.onNext(result)
                    self.modifyCustomerDataForFavorite(draftOrderId: result.draftOrder.id)
                }).disposed(by: disposeBag)
            
        }
    }
    
    
    private func modifyCustomerDataForFavorite(draftOrderId:Int) {
        let user = getUserFromUserDefaults()
        if(user!.favouriteId == 0) {
            self.customerProvider.editCustomer(id: user!.id , editCustomer: EditCustomer(customer: EditCustomerItem(id: user!.id, email: user!.email, firstName: user!.username, password: user!.password, cartId: "\(user!.cartId)", favouriteId: "\(draftOrderId)")))
                .subscribe(onNext: {[weak self] userResult in
                    guard let `self` = self else {fatalError()}
                    self.editCustomerSubject.onNext(userResult)
                    let newUser = User(id: user!.id , email: user!.email, username: user!.username, isLoggedIn: true, isDiscount: false, password: user!.password, cartId: Int(userResult.customer.cartId) ?? 0 , favouriteId: Int(userResult.customer.cartId) ?? 0)
                    try! self.userDefaults.setObject(newUser, forKey: "user")
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func putDraftOrder() {
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
            }
        }
    }
    
    // MARK: - User from userDefaults
    //
    private func getUserFromUserDefaults() -> User? {
        do {
            return try UserDefaults.standard.getObject(forKey: "user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
