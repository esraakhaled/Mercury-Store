//
//  CartCoreData.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 07/06/2022.
//

import Foundation
import CoreData
extension CoreDataModel{
    
    func deleteCartItem(productID:Int)->Bool{
        if(isBothProduct(id: productID)){
            var Product = getItemByID(productID: productID)
            Product.producrState = productStates.favourite.rawValue
            Product.productQTY = 0
            return (update(updateitem: Product)).1
        }else{
            return delete(itemID: productID)
        }
    }
    func isCartProduct (id :Int) -> Bool {
        var results: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entity)
        fetchRequest.predicate =  NSPredicate(format: "\(productCoredataAttr.id.rawValue) = %@ AND (\(productCoredataAttr.state.rawValue)  = %@ OR \(productCoredataAttr.state.rawValue) = %@)", argumentArray: [id as CVarArg, productStates.cart.rawValue , productStates.both.rawValue])
        do {
            results = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return !results.isEmpty
    }
    func insertCartProduct(product:SavedProductItem)->Bool{
        if (isProductFavourite(id: Int(truncating: NSDecimalNumber(decimal: product.productID)))) {
            var product = getItemByID(productID: Int(truncating: NSDecimalNumber(decimal: product.productID)))
            product.productQTY = product.productQTY+1
            product.producrState = productStates.both.rawValue
            return update(updateitem: product).1
        }
        else if(!isProductExist(id: Int(truncating: NSDecimalNumber(decimal: product.productID)))){
            return insert(item: product).1
        }else{
            var product = getItemByID(productID: Int(truncating: NSDecimalNumber(decimal: product.productID)))
            product.productQTY+=1
            return update(updateitem: product).1
        }
    }
}
