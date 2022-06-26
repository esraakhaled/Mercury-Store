//
//  PricesRulesClient.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 11/06/2022.
//

import Foundation
import RxSwift

protocol PricesRulesProvider: AnyObject {
    func getPricesRules() -> Observable<PricesRoleResponse>
    func getSinglePriceData(id:Int) -> Observable<SinglePriceRoleResponse>
}

class PricesRulesApi: PricesRulesProvider {
    
    func getPricesRules() -> Observable<PricesRoleResponse> {
        NetworkService().execute(PricesRules.getPricesRules)
    }
    
    func getSinglePriceData(id:Int) -> Observable<SinglePriceRoleResponse>{
        NetworkService().execute(PricesRules.getCoupon(id))
    }
}
