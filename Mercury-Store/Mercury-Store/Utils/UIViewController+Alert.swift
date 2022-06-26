//
//  UIViewController+Alert.swift
//  Mercury-Store
//
//  Created by mac hub on 16/06/2022.
//

import UIKit
import RxSwift

extension UIViewController {
    enum AlertAction {
        case `default`
        case cancel
    }
    
    func alert(title: String? = nil, message: String, defaultTitle: String, cancelTitle: String = "Cancel") -> Observable<AlertAction> {
        return Observable.create { [weak self] observable in
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: defaultTitle, style: .destructive, handler: { _ in
                observable.onNext(.default)
                observable.onCompleted()
            }))
            vc.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
                observable.onNext(.cancel)
                observable.onCompleted()
            }))
            self?.present(vc, animated: true)
            return Disposables.create {
                self?.dismiss(animated: true)
            }
        }
    }
    
    func alertWithOneButton(title: String? = nil, message: String, defaultTitle: String) -> Observable<AlertAction> {
        return Observable.create { [weak self] observable in
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: defaultTitle, style: .default, handler: { _ in
                observable.onNext(.default)
                observable.onCompleted()
            }))
            self?.present(vc, animated: true)
            return Disposables.create {
                self?.dismiss(animated: true)
            }
        }
    }
}

