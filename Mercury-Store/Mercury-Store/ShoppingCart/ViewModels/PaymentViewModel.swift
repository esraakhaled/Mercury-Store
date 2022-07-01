//
//  PaymentViewModel.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 14/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Braintree

protocol PaymentViewModelType{
    var CouponLoading: Driver<Bool> { get }
    var CouponInfo: Driver<PriceRule> { get}
    var CouponError: Driver<String?> { get }
    var paymentMethod:paymentOptions { set get }
    var subTotal: Double{ get }
    var total: BehaviorSubject<Double>{ get }
    var orderComplete: Driver<Bool>{get }
    func confirmOrder()
    func getItemByTitle(title:String)
    func getItemsById()
    func clearStack()
    func fetchCouponData()
}

class PaymentViewModel:PaymentViewModelType{
    var total: BehaviorSubject<Double>
    
    var subTotal: Double
    
    var Coupons:Driver<[PriceRule]>
    
    private let couponSubject = BehaviorRelay<PriceRule>(value: PriceRule() )
    private let couponsSubject = BehaviorRelay<[PriceRule]>(value: [])
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    private let completOrderSubject = BehaviorRelay<Bool>(value: false)
    private var braintreeClient: BTAPIClient?
    private let ordersProvider: OrdersProvider
    private weak var navigationFlow: ShoppingCartNavigationFlow!
    var CouponLoading: Driver<Bool>
    var CouponInfo: Driver<PriceRule>
    var CouponError: Driver<String?>
    var orderComplete: Driver<Bool>
    let userDefaults:UserDefaults
    let couponApi:PricesRulesProvider = PricesRulesApi()
    let disposeBag = DisposeBag()
    
    var paymentMethod: paymentOptions
    
    private let shippingAddress: CustomerAddress
    
    init(_userDefaults:UserDefaults = UserDefaults() ,paymentMethod:paymentOptions = .cashOnDelivery , ordersProvider: OrdersProvider = OrdersClient(),  shippingAddress: CustomerAddress,navigationFlow: ShoppingCartNavigationFlow) {
        userDefaults = _userDefaults
        self.shippingAddress = shippingAddress
        self.navigationFlow = navigationFlow
        CouponInfo = couponSubject.asDriver(onErrorJustReturn: PriceRule() )
        CouponLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        CouponError = errorSubject.asDriver(onErrorJustReturn: "Something went wrong")
        Coupons = couponsSubject.asDriver(onErrorJustReturn: [])
        orderComplete = completOrderSubject.asDriver(onErrorJustReturn: false)
        self.ordersProvider = ordersProvider
        total = BehaviorSubject<Double>(value: 0)
        self.subTotal = 0
        self.paymentMethod = paymentMethod
        self.totalItemsPrice()
        fetchCouponData()
    }
    
    private func checkIfHasCoupon()->Int?{
        do{
            let couponId = try userDefaults.getObject(forKey: "discountId", castTo: Int.self)
            return couponId
        }catch (_){
            return nil
        }
    }
    
    private func resetCoupon(){
        userDefaults.removeObject(forKey: "discountId")
    }
    
    func fetchCouponData(){
        self.couponApi.getPricesRules()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe{[weak self] (result) in
                guard let self = self else{ return }
                if let items = result.element{
                    self.couponsSubject.accept(items.priceRules)
                    self.getItemsById()
                }
            }.disposed(by: disposeBag)
    }
    
    func getItemByTitle(title:String ){
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            errorSubject.accept("please Enter Coupon Code")
            return
        }
        Coupons.asObservable().map{
            $0.filter{
                $0.title == title
            }
        }.observe(on: MainScheduler.asyncInstance).subscribe{[weak self] items in
            guard let self = self else{return}
            self.isLoadingSubject.accept(false)
                if let element = items.element{
                    if element.isEmpty{
                        self.couponSubject.accept(PriceRule())
                        self.handleCouponDiscount(discountValue: 0.0)
                        self.errorSubject.accept("please enter a valid coupon ")
                    }else{
                        self.couponSubject.accept(element[0])
                        self.handleCouponDiscount(discountValue: abs(Double(element[0].value) ?? 0.0))
                        self.errorSubject.accept(nil)
                    }
                }
        }.disposed(by: disposeBag)
    }
    
    func getItemsById(){
        guard let couponID = checkIfHasCoupon() else { return  }
        Coupons.asObservable().map{
            $0.filter{
                $0.id == couponID
            }
        }.observe(on: MainScheduler.asyncInstance)
            .subscribe{[weak self] items in
            guard let self = self else{return}
            self.isLoadingSubject.accept(false)
                if let element = items.element{
                    self.couponSubject.accept(element[0])
                    self.handleCouponDiscount(discountValue: abs(Double(element[0].value) ?? 0.0))
                }
            }.disposed(by: disposeBag)
    }
    
    func handleCouponDiscount(discountValue:Double){
        do{
            let temp = try total.value()
            if discountValue > temp{
                total.onNext(1)
            }else{
                self.totalItemsPrice()
                let totalMoney = subTotal - discountValue
                total.onNext( Double(round(100 * totalMoney) / 100))
            }
        }catch(_){
        }
    }
    
    private func getUserFromUserDefaults() -> User? {
        do {
            return try userDefaults.getObject(forKey: "user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func startCheckout(amount:String) {
        self.braintreeClient = BTAPIClient(authorization: PaymentModel.braintreeAuthorization)!
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        let request = BTPayPalCheckoutRequest(amount: amount)
        request.currencyCode = PaymentModel.currencyCode
        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                self.postOrder(financial_status: "paid")
            } else if let error = error {
                print(error)
            } else {
                print("the user canceled")
            }
        }
        
    }
    
    private func postOrder(financial_status:String = "authorized") {
        let user = getUserFromUserDefaults()
        let lineItems = getLineItems().map { LineItemDraft(quantity: $0.productQTY, variantID: $0.variantId, properties: [PropertyDraft(imageName: $0.productImage, inventoryQuantity: "\($0.inventoryQuantity)")])}
        let discountValue = abs (Double(couponSubject.value.value) ?? 0.0)
        let order = try! OrderItemTest(lineItems: lineItems, customer: CustomerId(id: user!.id), totalDiscounts: "\(discountValue)", current_total_discounts: "\(discountValue)", total_price: "\(total.value())", financial_status: financial_status, shippingAddress: AddressRequestItem(address1: shippingAddress.address1, address2: shippingAddress.address2, city: shippingAddress.city, company: shippingAddress.company, firstName: shippingAddress.firstName, lastName: shippingAddress.lastName, phone: shippingAddress.phone, province: shippingAddress.province, country: shippingAddress.country, zip: shippingAddress.zip, name: shippingAddress.name, provinceCode: shippingAddress.provinceCode, countryCode: shippingAddress.countryCode, countryName: shippingAddress.countryName))

        if (user != nil) {
            let newOrderRequest = PostOrderRequest(order: order)
        self.ordersProvider.postOrder(order: newOrderRequest)
            .subscribe(onNext: {[weak self] result in
                guard let `self` = self else {fatalError()}
                self.resetCoupon()
                CartCoreDataManager.shared.deleteAll()
                self.completOrderSubject.accept(true)
            }).disposed(by: disposeBag)
        }
    }
    
    private func getLineItems()->[SavedProductItem]{
        return CartCoreDataManager.shared.getDataFromCoreData()
    }
    
    private func totalItemsPrice(){
        var itemsPrice:Double = 0
        for item in getLineItems(){
            itemsPrice += item.productPrice*Double(item.productQTY)
        }
        subTotal = itemsPrice
        total.onNext(subTotal)
    }
    
    func confirmOrder(){
        switch(paymentMethod){
        case .withPaypal:
            do{
                let totalFees = try! total.value()
                self.startCheckout(amount: "\(totalFees)")
            }
        case .cashOnDelivery:
            self.postOrder()
        }
    }
    
    func clearStack(){
        self.navigationFlow.popToRoot()
    }
}
