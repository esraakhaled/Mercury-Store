//
//  ShoppingCartCellViewModel.swift
//  Mercury-Store
//
//  Created by mac hub on 30/05/2022.
//

import Foundation

struct CartCellViewModel {
    let row: CartRow
    var product: SavedProductItem! { row.products }
    var image: String? { product?.productImage }
    var name: String? { product?.productTitle }
    var price: String? { CurrencyHelper().checkCurrentCurrency("\(row.rowTotal)") }
    var count: String { "\(row.products.productQTY)" }
}

