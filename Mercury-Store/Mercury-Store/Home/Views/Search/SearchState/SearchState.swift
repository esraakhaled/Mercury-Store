//
//  SearchState.swift
//  Mercury-Store
//
//  Created by mac hub on 07/06/2022.
//

import Foundation


enum SearchAction {
    case viewIsLoaded([Product])
    case searchByName(String)
    case searchByPrice(Float)
    case sortAlphabetically(Bool)
}
struct SearchState {
    private(set) var sections: [SearchSection]
    
    init(_ sections: [SearchSection]) {
        self.sections = sections
    }
    
    static func empty() -> SearchState {
        SearchState([SearchSection([])])
    }
    
    func execute(_ action: SearchAction) -> SearchState {
        guard self.sections.count < 2 else {
            fatalError("SearchState only supports 1 section")
        }
        switch action {
        case .viewIsLoaded(let products):
            return SearchState([getArray(products)])
        case .searchByName(let name):
            return SearchState([sortByName(name, in: self.sections[0])])
        case .searchByPrice(let price):
            return SearchState([sortByPrice(price, in: self.sections[0])])
        case .sortAlphabetically:
            return .empty()

        }
        
    }
    
    private func getArray(_ products: [Product]) -> SearchSection {
        return SearchSection(products)
    }
    
    private func sortByName(_ searchValue: String, in section: SearchSection) -> SearchSection {
        return section.getArrayByName(for: searchValue)
    }
    
    private func sortByPrice(_ priceValue: Float , in section: SearchSection) -> SearchSection {
        return section.getArrayByPrice(for: priceValue)
    }
}

fileprivate extension SearchSection {
    
    func getElements(_ elements: [Product]) -> [Product]? {
        return self.rows
    }
    
    func getArrayByName(for searchValue: String) -> SearchSection {
        let namedItems =  rows.filter({$0.title.lowercased().contains(searchValue.lowercased())})
        return SearchSection(namedItems)
    }
    
    func getArrayByPrice(for price: Float) -> SearchSection {
        let pricedItems =  rows.filter({$0.variants.first?.price == price.formatted()})
        return SearchSection(pricedItems)
    }
}

