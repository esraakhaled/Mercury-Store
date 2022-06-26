//
//  ProductDetailViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 03/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
protocol ProductsDetailViewModelType: AnyObject{
    var countForPageControll: Observable<Int> { get }
    var product : Product{get}
    var bannerObservable: Driver<[ProductImage]> {get}
    var variantsObservable: Driver<[String]> { get }
    var colorsObservable: Driver<[String]> { get }
    var priceObservable: Observable<String> { get }
    var inventoryQuantityObservable: Observable<Int> { get }
    func sendImagesToCollection()
    func toggleFavourite()->Bool
    var isProductFavourite:Bool{get}
    var isLogged:Bool{get}
    func modifyOrderInCartIfCartIdIsNil(_ product: Product, variant: Variant)
    func popViewController()
    func sendVariantsToCollection()
    func setPriceForSelectedVariantIndex()
    func setInventoryQuantity()
    var indexSubject: BehaviorSubject<Int> { get }
    func sendColorsToCollection()
}

final class ProductsDetailViewModel: ProductsDetailViewModelType {
    var isLogged: Bool{
        getCurrentUserId() != nil
    }
    
    private let productImagesSubject = PublishSubject<[ProductImage]>()
    private weak var productDetailsNavigationFlow: ProductDetailsNavigationFlow?
    private let coreDataShared: CoreDataModel
    private let cartOrderSubject = PublishSubject<DraftOrderResponseTest>()
    private let userDefaults: UserDefaults
    private let ordersProvider: OrdersProvider
    private let disposeBag = DisposeBag()
    private let customerProvider: CustomerProvider
    private let editCustomerSubject = PublishSubject<RegisterResponse>()
    private let variantsSubject = PublishSubject<[String]>()
    private let priceSubject = PublishSubject<String>()
    private let inventoryQuantitySubject = BehaviorSubject<Int>(value: 0)
    private let colorsSubject = PublishSubject<[String]>()
    var product: Product
    var countForPageControll: Observable<Int>
    var bannerObservable: Driver<[ProductImage]>
    var variantsObservable: Driver<[String]> { variantsSubject.asDriver(onErrorJustReturn: []) }
    var priceObservable: Observable<String> { priceSubject.asObserver() }
    var inventoryQuantityObservable: Observable<Int> { inventoryQuantitySubject.asObserver() }
    var indexSubject = BehaviorSubject<Int>(value: 0)
    var colorsObservable: Driver<[String]> { colorsSubject.asDriver(onErrorJustReturn: [])}
    
    init(with productDetailsNavigationFlow: ProductDetailsNavigationFlow,product:Product, coreDataShared: CoreDataModel = CoreDataModel.coreDataInstatnce,ordersProvider: OrdersProvider = OrdersClient(),
         userDefaults: UserDefaults = UserDefaults.standard, customerProvider: CustomerProvider = CustomerClient()) {
        countForPageControll = Observable.just(product.images.count)
        bannerObservable = productImagesSubject.asDriver(onErrorJustReturn: [])
        self.product = product
        self.coreDataShared = coreDataShared
        self.ordersProvider = ordersProvider
        self.userDefaults = userDefaults
        self.customerProvider = customerProvider
        self.productDetailsNavigationFlow = productDetailsNavigationFlow
    }
    
    func sendImagesToCollection() {
        productImagesSubject.onNext(product.images)
    }
    
    var isProductFavourite: Bool{
        if getCurrentUserId() != nil{
            return CoreDataModel.coreDataInstatnce.isProductFavourite(id: product.id)
        }else {
            return false
        }
    }
    
    func toggleFavourite() -> Bool  {
        let product = SavedProductItem(
            inventoryQuantity: product.variants[0].inventoryQuantity, variantId: product.variants[0].id,
            productID: Decimal(product.id),
            productTitle: product.title,
            productImage: product.image.src ,
            productPrice: Double(product.variants[0].price) ?? 0 ,
            productQTY: 0 , producrState: productStates.favourite.rawValue)
        
        if getCurrentUserId() != nil{
             return CoreDataModel.coreDataInstatnce.toggleFavourite(product: product)
        }else {
            return false
        }
    }
    func sendVariantsToCollection() {
        try! variantsSubject.onNext(product.options[indexSubject.value()].values)
    }
    func popViewController() {
        productDetailsNavigationFlow?.popViewController()
    }
    func sendColorsToCollection() {
        colorsSubject.onNext(product.options[1].values)
    }
    private func saveToCart() {
        if(try! product.variants[indexSubject.value()].inventoryQuantity != 0) {
            let _ = try! coreDataShared.insertCartProduct(product: SavedProductItem(inventoryQuantity: product.variants[indexSubject.value()].inventoryQuantity, variantId: product.variants[indexSubject.value()].id, productID: Decimal(product.id), productTitle: product.title, productImage: product.image.src , productPrice: Double(product.variants[indexSubject.value()].price) ?? 0 , productQTY: 1 , producrState: productStates.cart.rawValue))
            
            coreDataShared.observeProductCount()
        }
        
    }
    func setPriceForSelectedVariantIndex() {
        try! priceSubject.onNext(product.variants[indexSubject.value()].price)
    }
    
    func setInventoryQuantity() {
        try! inventoryQuantitySubject.onNext(product.variants[indexSubject.value()].inventoryQuantity)
    }
    
    private func postOrderIntoCart(_ product: Product, variant: Variant) {
        let user = getUserFromUserDefaults()
        if (user != nil) {
            let newLineItemDraft = LineItemDraft(quantity: 1, variantID: variant.id, properties: [PropertyDraft(imageName: product.image.src, inventoryQuantity: "\(variant.inventoryQuantity)")])
            let newOrderRequest = DraftOrdersRequest(draftOrder: DraftOrderItem(lineItems: [newLineItemDraft], customer: CustomerId(id: user!.id), useCustomerDefaultAddress: true))
            self.ordersProvider.postDraftOrder(order: newOrderRequest)
                .subscribe(onNext: {[weak self] result in
                    guard let `self` = self else {fatalError()}
                    self.cartOrderSubject.onNext(result)
                    self.modifyCustomerData(draftOrderId: result.draftOrder.id)
                }).disposed(by: disposeBag)
            
        }
    }
    
    func modifyCustomerData(draftOrderId: Int) {
        let user = getUserFromUserDefaults()
        if(user!.cartId == 0) {
            self.customerProvider.editCustomer(id: user!.id , editCustomer: EditCustomer(customer: EditCustomerItem(id: user!.id, email: user!.email, firstName: user!.username, password: user!.password, cartId: "\(draftOrderId)", favouriteId: "0")))
                .subscribe(onNext: {[weak self] userResult in
                    guard let `self` = self else {fatalError()}
                    self.editCustomerSubject.onNext(userResult)
                    let newUser = User(id: user!.id , email: user!.email, username: user!.username, isLoggedIn: true, isDiscount: false, password: user!.password, cartId: Int(userResult.customer.cartId) ?? 0 , favouriteId: user!.favouriteId)
                    try! self.userDefaults.setObject(newUser, forKey: "user")
                }).disposed(by: self.disposeBag)
        }
    }
  
    func modifyOrderInCartIfCartIdIsNil(_ product: Product, variant: Variant) {
        let user = getUserFromUserDefaults()
        if(user != nil) {
            if(user!.cartId == 0) {
                self.postOrderIntoCart(product, variant: variant)
            }
        }
        saveToCart()
        
    }
    
    private func getUserFromUserDefaults() -> User? {
        do {
            return try userDefaults.getObject(forKey: "user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}



