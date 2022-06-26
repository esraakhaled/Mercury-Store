//
//  WishListViewModel.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 04/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
protocol WishListViewModelType {
    var products: Driver<[SavedProductItem]> { get}
    var error: Driver<String?> { get }
    var emptyView: Driver<Bool> { get }
    func getFavouriteItems()
    func updateItem(item:SavedProductItem)
    func deleteItem(item:SavedProductItem)
    func isFavouriteItem(productID:Int)->Bool
}
class WishListViewModel:WishListViewModelType{
    var products: Driver<[SavedProductItem]>
    var error: Driver<String?>
    
    private let emptyViewSubject = BehaviorRelay<Bool>(value: true)
    var emptyView: Driver<Bool> {
        return emptyViewSubject
            .asDriver(onErrorJustReturn: true)
    }
    
    private let productSubject = BehaviorRelay<[SavedProductItem]>(value: [])
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    let coreDataModel:CoreDataModel
    let disposeBag = DisposeBag()
    init(){
        coreDataModel = CoreDataModel.coreDataInstatnce
        products = productSubject.asDriver(onErrorJustReturn: [])
        error = errorSubject.asDriver(onErrorJustReturn: "Somthing went wrong")
    }
    func getFavouriteItems() {
        self.productSubject.accept([])
        self.errorSubject.accept(nil)
        let items = self.coreDataModel.getItemsByUserID()
        if(items.0.isEmpty) {
            self.emptyViewSubject.accept(false)
        }else {
            if(items.1 == nil){
                self.productSubject.accept(items.0)
                self.errorSubject.accept(nil)
                self.emptyViewSubject.accept(true)
            }else {
                self.errorSubject.accept(items.1?.localizedDescription)
            }
        }
        
    }
    
    func updateItem(item: SavedProductItem) {
        let state = self.coreDataModel.update(updateitem: item)
        if (state.1) {
            getFavouriteItems()
            self.errorSubject.accept(nil)
        }
        else {
            self.errorSubject.accept("Somthing went wrong")
            
        }
    }
    
    func deleteItem(item: SavedProductItem) {
        let state = self.coreDataModel.deleteFavouriteProduct(productID: Int(NSDecimalNumber(decimal: item.productID)))
        if (state) {
            self.errorSubject.accept(nil)
            getFavouriteItems()
        }
        else {
            self.errorSubject.accept("Somthing went wrong")
        }
    }
    func isFavouriteItem(productID:Int)->Bool{
        return self.coreDataModel.isProductFavourite(id: productID)
    }
    
    
}
