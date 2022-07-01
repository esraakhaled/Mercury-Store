//
//  String+isValidEmail.swift
//  Mercury-Store
//
//  Created by mac hub on 10/06/2022.
//

import Foundation

extension String {
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
}
extension String {
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^(\01|01|00201)[0-2,5]{1}[0-9]{8}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: self)
    }
}
