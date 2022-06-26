//
//  SavedProductItem.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 03/06/2022.
//

import Foundation
struct SavedProductItem{
    var inventoryQuantity: Int
    var variantId: Int
    var productID:Decimal
    var productTitle:String
    var productImage:String
    var productPrice:Double
    var productQTY:Int
    var producrState:Int
    var user_id:[Int]
    
    init(inventoryQuantity: Int , variantId: Int ,productID:Decimal ,productTitle:String ,productImage:String ,productPrice:Double ,productQTY:Int ,producrState:Int , user_id:[Int] = []){
        self.inventoryQuantity = inventoryQuantity
        self.variantId = variantId
        self.productID = productID
        self.productTitle = productTitle
        self.productImage = productImage
        self.productPrice = productPrice
        self.productQTY = productQTY
        self.producrState = producrState
        self.user_id = user_id
    }
}
extension SavedProductItem {
    init() {
        productTitle = ""
        productID = 0
        productImage = ""
        productPrice = 0
        productQTY = 0
        // 0 favourite -- 1 cart -- 2cart
        producrState = 0
        variantId = 0
        inventoryQuantity = 0
        user_id = []
    }
}

extension SavedProductItem: Equatable {}
