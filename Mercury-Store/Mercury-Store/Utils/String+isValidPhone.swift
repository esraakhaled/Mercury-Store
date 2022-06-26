//
//  String+isValidPhone.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 13/06/2022.
//

import Foundation

extension String {
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^(\01|01|00201)[0-2,5]{1}[0-9]{8}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: self)
    }
}


