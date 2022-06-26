//
//  StorageProtocol.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 04/06/2022.
//

import Foundation
import RxSwift

protocol StorageInputs {
    
    func getItems(productState:productStates) -> ([SavedProductItem], Error?)
    func insert(item:SavedProductItem) -> (SavedProductItem, Bool)
    func update(updateitem:SavedProductItem) -> (SavedProductItem, Bool)
}

protocol StorageOutputs {
    var items: Observable<SavedProductItem?> { get }
}

protocol StorageProtocol {
    var inputs: StorageInputs { get }
    var outputs: StorageOutputs { get }
}
