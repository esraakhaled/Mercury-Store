//
//  UIViewController+UIAlert.swift
//  Mercury-Store
//
//  Created by mac hub on 13/06/2022.
//

import UIKit
import RxSwift

struct AlertView {
    public static func showAlertBox(title: String, message: String, handler: ((UIAlertAction)->Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        return alert
    }
}

extension UIAlertController {
    func present(on viewController: UIViewController, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: true, completion: completion)
    }
}
