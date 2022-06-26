//
//  UITableView+EmptyState.swift
//  Mercury-Store
//
//  Created by mac hub on 01/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    
    func setEmptyState(message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.textAlignment = .center
        label.text = message
        label.style(.headLine)

        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func removeEmptyState() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension Reactive where Base: UIView {
    
    func isEmpty() -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
        }
    }
}

