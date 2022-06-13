//
//  BannerCollectionViewModel.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 12/06/2022.
//

import Foundation
protocol PriceRoleCellViewModelType{
    func savePriceRole(itemId:Int)->Bool
}

class PriceRoleCellViewModel:PriceRoleCellViewModelType{
    var userDefaults:UserDefaults
    init(_userDefaults:UserDefaults) {
        userDefaults = _userDefaults
    }
    func savePriceRole(itemId: Int) -> Bool {
        do{
            try? userDefaults.setObject(itemId, forKey: "discountId")
            return true
        }catch (_){
            return false
        }
    }
    

}
