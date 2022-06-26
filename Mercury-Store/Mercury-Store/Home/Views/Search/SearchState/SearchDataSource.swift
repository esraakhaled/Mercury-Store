//
//  SearchDataSource.swift
//  Mercury-Store
//
//  Created by mac hub on 07/06/2022.
//

import Foundation
import RxDataSources

struct SearchSection {
    let uuid: UUID
    var rows: [Product]
}

extension SearchSection {
    init(_ rows: [Product]) {
        self.uuid = UUID()
        self.rows = rows
    }
}

extension SearchSection: SectionModelType {
    var identity: UUID { uuid }
    var items: [Product] { rows }
    
    init(original: SearchSection, items: [Product]) {
        self = original
        self.rows = items
    }
}
