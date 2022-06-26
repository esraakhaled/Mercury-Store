//
//  DraftOrdersViewModels.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 10/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol CustomersOrdersViewModelsType {
    var isLoading: Driver<Bool> { get }
    var error: Driver<String?> { get }
    var user: User? { get}
    var orders: Driver<[CustomerOrders]>{get}
}

class CustomersOrdersViewModels:CustomersOrdersViewModelsType {
    private let typesSubject = BehaviorRelay<[CustomerOrders]>(value: [])
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    private let ordersProvider :OrdersProvider
    private let disposeBag = DisposeBag()
    private let userDefaults: UserDefaults
    
    var orders: Driver<[CustomerOrders]>
    var isLoading: Driver<Bool>
    var error: Driver<String?>
    
    var user: User?
    
    
    init(_ userDefaults: UserDefaults = UserDefaults.standard, ordersProvider :OrdersProvider = OrdersClient()) {
        orders = typesSubject.asDriver(onErrorJustReturn: [])
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: "Something went wrong")
        self.ordersProvider = ordersProvider
        self.userDefaults = userDefaults
        self.user = getUser()
        fetchOrders()
    }
    private func fetchOrders(){
        self.typesSubject.accept([])
        self.isLoadingSubject.accept(true)
        self.errorSubject.accept(nil)
        guard let user = user else {
            return
        }
        self.ordersProvider.getOrderList(with: user.id)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (result) in
                guard let self = self else{return}
                self.isLoadingSubject.accept(false)
                print(result)
                self.typesSubject.accept(result.orders)
            } onError: {[weak self] (error) in
                self?.isLoadingSubject.accept(false)
                self?.errorSubject.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    private func getUser() -> User? {
        do {
            return try userDefaults.getObject(forKey: "user", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
