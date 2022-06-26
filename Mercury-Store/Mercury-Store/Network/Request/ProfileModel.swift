//
//  ProfileModel.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//
import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}



// MARK: - Customer
struct Customer: Codable {
    let customer: CustomerClass
}

struct AllCustomers:Codable {
    let customers: [CustomerResponse]
}

// MARK: - CustomerClass
struct CustomerClass: Codable {
    let firstName, lastName, email: String
    let password : String
    let cartId: String
    let favouriteId: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password = "tags"
        case cartId = "note"
        case favouriteId = "multipass_identifier"
    }
}

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let customer: CustomerResponse
}

struct CustomerResponse: Codable {
    let id: Int
    let email: String
    let firstName, lastName: String
    let cartId: String
    let favouriteId: String
    let verifiedEmail: Bool
    let taxExempt: Bool
    let phone: String?
    let password: String
    let addresses: [Address]
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case cartId = "note"
        case favouriteId = "multipass_identifier"
        case verifiedEmail = "verified_email"
        case taxExempt = "tax_exempt"
        case phone
        case password = "tags"
        case addresses
    }
}

// MARK: - Address
struct Address: Codable {
    let id, customerID: Int
    let firstName, lastName: String
    let address1: String
    let address2: String?
    let city, province, country, zip: String
    let phone, name, provinceCode, countryCode: String
    let countryName: String
    let addressDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}


struct EditCustomer: Codable {
    let customer: EditCustomerItem
}

// MARK: - Customer
struct EditCustomerItem: Codable {
    let id: Int
    let email, firstName, password, cartId: String
    let favouriteId: String
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case password = "tags"
        case cartId = "note"
        case favouriteId = "multipass_identifier"
    }
}
