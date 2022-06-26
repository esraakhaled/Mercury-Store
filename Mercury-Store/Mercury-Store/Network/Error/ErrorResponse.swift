//
//  ErrorResponse.swift
//  Mercury-Store
//
//  Created by mac hub on 09/06/2022.
//

import Foundation

enum CustomerErrors: String {
    case emailExists = "Email already registered please login."
    case emailNotExists = "Your email does not exist, please try to register first."
    case checkYourCredentials = "Something went wrong, email or password is wrong."
    case newAddressError = "Something went wrong, please try again later."
    case emailIsNotValid = "Please, enter valid email"
    case passwordIsNotValid = "Please, enter valid password"
}
