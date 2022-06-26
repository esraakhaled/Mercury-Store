//
//  User.swift
//  Mercury-Store
//
//  Created by mac hub on 10/06/2022.
//

import Foundation


struct User: Codable {
    let id: Int
    let email: String
    let username: String
    let isLoggedIn: Bool
    let isDiscount: Bool
    let password: String
    let cartId: Int
    let favouriteId: Int
}
