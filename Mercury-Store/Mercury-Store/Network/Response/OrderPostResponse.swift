//
//  OrderPostResponse.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 11/06/2022.
//

import Foundation


// MARK: - CustomerEditResonse
struct DraftOrderResponseTest: Codable {
    let draftOrder: DraftOrderTest

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DraftOrderTest: Codable {
    let id: Int
    let note: String?
    let email: String
    let taxesIncluded: Bool
    let currency: String
    let createdAt, updatedAt: Date
    let name, status: String
    let lineItems: [LineItem]
    let invoiceURL: String
    let taxLines: [TaxLine]
    let tags: String
    let totalPrice, subtotalPrice, totalTax: String
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id, note, email
        case taxesIncluded = "taxes_included"
        case currency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name, status
        case lineItems = "line_items"
        case invoiceURL = "invoice_url"
        case taxLines = "tax_lines"
        case tags
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}
// MARK: - EmailMarketingConsent
struct EmailMarketingConsent: Codable {
    let state, optInLevel: String
    //let consentUpdatedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
    }
}


// MARK: - LineItem
struct LineItem: Codable {
    let id, variantID, productID: Int
    let title, variantTitle, sku, vendor: String
    let quantity: Int
    let requiresShipping, taxable, giftCard: Bool
    let fulfillmentService: String
    let grams: Int
    let taxLines: [TaxLine]
    let name: String
    let price, adminGraphqlAPIID: String
    let properties: [PropertyDraft]
    
    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku, vendor, quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case taxLines = "tax_lines"
        case name, price
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case properties
    }
}


// MARK: - TaxLine
struct TaxLine: Codable {
    let rate: Double
    let title, price: String
}

struct EmptyObject: Codable {
    
}


// MARK: - OrderTest
struct PostOrderResponseTest: Codable{
    let order: OrdersTest
}


struct OrdersTest: Codable {
    let id: Int?
    let note: String?
    let email: String
    let taxesIncluded: Bool
    let createdAt, updatedAt: Date
    let name: String
    let lineItems: [LineItem]
    let taxLines: [TaxLine]
    let tags: String
    let totalPrice, subtotalPrice, totalTax: String
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id, note, email
        case taxesIncluded = "taxes_included"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
        case lineItems = "line_items"
        case taxLines = "tax_lines"
        case tags
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}


