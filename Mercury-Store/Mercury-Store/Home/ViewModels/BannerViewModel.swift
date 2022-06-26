//
//  BannerViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 23/05/2022.
//

import RxSwift
import RxCocoa

protocol BannerViewModelType {
    var isLoading: Driver<Bool> { get }
    var pricesRules: Driver<[PriceRule]> { get}
    var error: Driver<String?> { get }
    var countForPageControll: Driver<Int> { get }
}

final class BannerViewModel: BannerViewModelType {
    var isLoading: Driver<Bool>
    
    var pricesRules: Driver<[PriceRule]>
    
    var error: Driver<String?>
    
    var countForPageControll: Driver<Int>
    
    private let priceRuleSubject = BehaviorRelay<[PriceRule]>(value: [])
    private let countForPageControllSubject = BehaviorRelay<Int>(value: 0)
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    var pricesRuleClient:PricesRulesProvider = PricesRulesApi()
    let disposeBag = DisposeBag()
    
    init() {
        pricesRules = priceRuleSubject.asDriver(onErrorJustReturn: [])
        countForPageControll = countForPageControllSubject.asDriver(onErrorJustReturn: 0)
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: "Somthing went wrong")
        fetchPricesRule()
    }
    
    private func fetchPricesRule(){
        pricesRuleClient.getPricesRules()
            .observe(on: MainScheduler.asyncInstance).subscribe{
                [weak self] (result) in
                guard let self = self else{return}
                self.priceRuleSubject.accept(result.priceRules)
                self.countForPageControllSubject.accept(result.priceRules.count)
                self.isLoadingSubject.accept(false)
                self.errorSubject.accept(nil)
                } onError: {[weak self] (error) in
                    guard let self = self else{return}
                    self.priceRuleSubject.accept([])
                    self.countForPageControllSubject.accept(0)
                    self.isLoadingSubject.accept(false)
                    self.errorSubject.accept("something went wrong")
                    print(error)
                }.disposed(by: disposeBag)
    }
}

