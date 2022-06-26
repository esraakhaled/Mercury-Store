//
//  AddressRequest.swift
//  Mercury-Store
//
//  Created by mac hub on 13/06/2022.
//

import Foundation

// MARK: - AddressRequest
struct AddressRequest: Codable {
    let address: AddressRequestItem
}


// MARK: - Address
struct AddressRequestItem: Codable {
    let address1, address2, city, company: String
    let firstName, lastName, phone, province: String
    let country, zip, name, provinceCode: String
    let countryCode, countryName: String
   
    enum CodingKeys: String, CodingKey {
        case address1, address2, city, company
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, province, country, zip, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        
    }
}
struct AddressesResponse: Codable {
let addresses: [CustomerAddress]
}

// MARK: - AddressResponse
struct AddressResponse: Codable {
    let customerAddress: CustomerAddress

    enum CodingKeys: String, CodingKey {
        case customerAddress = "customer_address"
    }
}


// MARK: - CustomerAddress
struct CustomerAddress: Codable {
    let id, customerID: Int
    let firstName, lastName, company, address1: String
    let address2, city, province, country: String
    let zip, phone, name, provinceCode: String
    let countryCode, countryName: String
    let customerAddressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company, address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case customerAddressDefault = "default"
    }
}

struct AddressRequestPut: Codable {
    let address: AddressRequestItemPut
}


// MARK: - Address
struct AddressRequestItemPut: Codable {
    let address1, address2, city, company: String
    let firstName, lastName, phone, province: String
    let country, zip, name, provinceCode: String
    let countryCode, countryName: String
    let id :Int
    enum CodingKeys: String, CodingKey {
        case address1, address2, city, company
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, province, country, zip, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case id
    }
}
