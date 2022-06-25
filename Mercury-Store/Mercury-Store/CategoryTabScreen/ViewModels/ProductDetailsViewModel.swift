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
    var priceObservable: Driver<String> { get }
    
    var inventoryQuantityObservable: Driver<Int> { get }
    func sendImagesToCollection()
    func toggleFavourite()->Bool
    var isProductFavourite:Bool{get}
    func modifyOrderInCartIfCartIdIsNil(_ variantId: Int)
    func popViewController()
    func sendVariantsToCollection()
    func setPriceForSelectedVariantIndex(index: Int)
    func setInventoryQuantity(index: Int)
}

final class ProductsDetailViewModel: ProductsDetailViewModelType {
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
    private let inventoryQuantitySubject = BehaviorRelay<Int>(value: 0)
    var product: Product
    var countForPageControll: Observable<Int>
    var bannerObservable: Driver<[ProductImage]>
    var variantsObservable: Driver<[String]> { variantsSubject.asDriver(onErrorJustReturn: []) }
    var priceObservable: Driver<String> { priceSubject.asDriver(onErrorJustReturn: "")}
    var inventoryQuantityObservable: Driver<Int> { inventoryQuantitySubject.asDriver(onErrorJustReturn: 0) }
    
    
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
        return CoreDataModel.coreDataInstatnce.isProductFavourite(id: product.id)
    }
    func toggleFavourite() -> Bool  {
        return coreDataShared.toggleFavourite(product: SavedProductItem(
            inventoryQuantity: product.variants[0].inventoryQuantity, variantId: product.variants[0].id,
            productID: Decimal(product.id),
            productTitle: product.title,
            productImage: product.image.src ,
            productPrice: Double(product.variants[0].price) ?? 0 ,
            productQTY: 0 , producrState: productStates.favourite.rawValue))
    }
    func sendVariantsToCollection() {
        variantsSubject.onNext(product.options[0].values)
    }
    func popViewController() {
        productDetailsNavigationFlow?.popViewController()
    }
    
    private func saveToCart() {
        let _ = coreDataShared.insertCartProduct(product: SavedProductItem(inventoryQuantity: product.variants[0].inventoryQuantity, variantId: product.variants[0].id, productID: Decimal(product.id), productTitle: product.title, productImage: product.image.src , productPrice: Double(product.variants[0].price) ?? 0 , productQTY: 1 , producrState: productStates.cart.rawValue))
        
        coreDataShared.observeProductCount()
    }
    func setPriceForSelectedVariantIndex(index: Int) {
        priceSubject.onNext(product.variants[index].price)
    }
    
    func setInventoryQuantity(index: Int) {
        inventoryQuantitySubject.accept(product.variants[index].inventoryQuantity)
    }

    
    private func postOrderIntoCart(_ variantId: Int) {
        let user = getUserFromUserDefaults()
        if (user != nil) {
            let newItemDraft = LineItemDraft(quantity: 1, variantID: variantId)
            let savedItemsInCart = CartCoreDataManager.shared.getDataFromCoreData()
            let coreDataLineDraft = savedItemsInCart.map { LineItemDraft(quantity: $0.productQTY, variantID: $0.variantId)}
            var coreDataLineDraftWithNewElement = coreDataLineDraft
            coreDataLineDraftWithNewElement.append(newItemDraft)
            
            let newOrderRequest = DraftOrdersRequest(draftOrder: DraftOrderItem(lineItems: coreDataLineDraftWithNewElement, customer: CustomerId(id: user!.id), useCustomerDefaultAddress: true))
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
    
    func modifyOrderInCartIfCartIdIsNil(_ variantId: Int) {
        let user = getUserFromUserDefaults()
        if(user != nil) {
            if(user!.cartId != 0) {
                self.ordersProvider.modifyExistingOrder(with: user!.cartId, and: PutOrderRequest(draftOrder: ModifyDraftOrderRequest(dratOrderId: user!.cartId, lineItems: [LineItemDraft(quantity: 1, variantID: variantId)])))
                    .subscribe(onNext: {[weak self] result in
                        guard let `self` = self else {fatalError()}
                        self.cartOrderSubject.onNext(result)
                        self.modifyCustomerData(draftOrderId: user!.cartId)
                    }).disposed(by: disposeBag)
            } else {
                self.postOrderIntoCart(variantId)
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



