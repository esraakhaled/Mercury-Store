//
//  CartSection.swift
//  Mercury-Store
//
//  Created by mac hub on 01/06/2022.
//

import Foundation
import RxDataSources

struct CartSection {
    let uuid: UUID
    var rows: [CartRow]
}

extension CartSection {
    init(_ rows: [CartRow]) {
        self.uuid = UUID()
        self.rows = rows
    }
    
    var totalCount: Int {
        rows.reduce(0) { result, row in
            result + row.products.productQTY
        }
    }
    
    var totalPrice: Double{
        rows.reduce(0) { result, row in
            result + row.products.productPrice
        }
    }
    var sectionTotal: Double {
        rows.reduce(0) { result, row in
            result + row.rowTotal
        }
    }
}

extension CartSection: SectionModelType {
    var identity: UUID { uuid }
    var items: [CartRow] { rows }
    
    init(original: CartSection, items: [CartRow]) {
        self = original
        self.rows = items
    }
}

