//
//  CellProfileModel.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 25/05/2022.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa


enum ProfileSectionModel {
    case myAccountSection(title: String, items: [ProfileSectionItem])
    case aboutSection(title: String, items: [ProfileSectionItem])
}
enum ProfileSectionItem {
    case myAccountItem(image: UIImage,title: String)
    case currencyItem
    case aboutItem(image: UIImage,title: String)
}
extension ProfileSectionModel: SectionModelType {
    typealias Item = ProfileSectionItem
    
    var items: [ProfileSectionItem] {
        switch self {
        case .myAccountSection(title: _, items: let items):
            return items.map { $0 }
        case .aboutSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: ProfileSectionModel, items: [Item]) {
        switch original {
        case let .myAccountSection(title: title, items: _):
            self = .myAccountSection(title: title, items: items)
        case let .aboutSection(title: title, items: _):
            self = .aboutSection(title: title, items: items)
        }
    }
}

extension ProfileSectionModel {
    var title: String {
        switch self {
        case .myAccountSection(title: let title, items: _):
            return title
        case .aboutSection(title: let title, items: _):
            return title
        }
    }
}
