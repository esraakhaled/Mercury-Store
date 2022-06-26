//
//  ProductCellViewModel.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 07/06/2022.
//
import Foundation

protocol ProductCellViewModelType{
    func toggleFavourite(product:SavedProductItem)->Bool
    func getFavouriteState(productID:Int)->Bool
    var userID:Int?{get}
}

class ProductCellViewModel:ProductCellViewModelType{
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
    
}
