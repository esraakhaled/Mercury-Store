//
//  CustomerOrdersResponse.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 19/06/2022.
//

import Foundation
struct CustomerOrdersList: Codable {
    let orders: [CustomerOrders]
}

// MARK: - Order
struct CustomerOrders: Codable {
    let id: Int
    let cartToken: String?
    let checkoutID: Int?
    let checkoutToken: String?
    let confirmed: Bool?
    let contactEmail: String?
    let createdAt: Date
    let currency: String
    let currentSubtotalPrice: String
    let currentTotalDiscounts: String
    let currentTotalPrice: String
    let currentTotalTax: String?
    let email: String?
    let estimatedTaxes: Bool?
    let financialStatus: String
    let gateway: String?
    let landingSite: String?
    let landingSiteRef: String?
    let name: String
    let number, orderNumber: Int?
    let orderStatusURL: String?
    let paymentGatewayNames: [String?]
    let phone: String?
    let presentmentCurrency: String?
    let processedAt: Date?
    let processingMethod, reference: String?
    let referringSite: String?
    let sourceName: String?
    let subtotalPrice: String?
    let tags: String?
    let taxLines: [TaxLine?]
    let taxesIncluded, test: Bool
    let token, totalDiscounts: String?
    let totalLineItemsPrice: String?
    let totalPrice: String
    let totalPriceUsd: String?
    let totalTax: String?
    let totalTipReceived: String?
    let totalWeight: Int?
    let updatedAt: Date?
    let billingAddress: OrderAddressInfo?
    let shippingAddress: OrderAddressInfo?
    let lineItems: [OrdersInfoLineItem]
    let shippingLines: [ShippingLine]

    enum CodingKeys: String, CodingKey {
        case id
        case cartToken = "cart_token"
        case checkoutID = "checkout_id"
        case checkoutToken = "checkout_token"
        case confirmed
        case shippingAddress = "shipping_address"
        case contactEmail = "contact_email"
        case createdAt = "created_at"
        case currency
        case currentSubtotalPrice = "current_subtotal_price"
        case currentTotalDiscounts = "current_total_discounts"
        case currentTotalPrice = "current_total_price"
        case currentTotalTax = "current_total_tax"
        case email
        case estimatedTaxes = "estimated_taxes"
        case financialStatus = "financial_status"
        case gateway
        case landingSite = "landing_site"
        case landingSiteRef = "landing_site_ref"
        case name
        case number
        case orderNumber = "order_number"
        case orderStatusURL = "order_status_url"
        case paymentGatewayNames = "payment_gateway_names"
        case phone
        case presentmentCurrency = "presentment_currency"
        case processedAt = "processed_at"
        case processingMethod = "processing_method"
        case reference
        case referringSite = "referring_site"
        case sourceName = "source_name"
        case subtotalPrice = "subtotal_price"
        case tags
        case taxLines = "tax_lines"
        case taxesIncluded = "taxes_included"
        case test, token
        case totalDiscounts = "total_discounts"
        case totalLineItemsPrice = "total_line_items_price"
        case totalPrice = "total_price"
        case totalPriceUsd = "total_price_usd"
        case totalTax = "total_tax"
        case totalTipReceived = "total_tip_received"
        case totalWeight = "total_weight"
        case updatedAt = "updated_at"
        case billingAddress = "billing_address"
        case lineItems = "line_items"
        case shippingLines = "shipping_lines"
    }
}



enum Currency: String, Codable {
    case usd = "USD"
}


// MARK: - Money
struct Money: Codable {
    let amount: String
    let currencyCode: Currency

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}
// MARK: - OriginAddress
struct OriginAddress: Codable {
}

// MARK: - ShippingLine
struct ShippingLine: Codable {
    let id: Int
    let code: String
    let discountedPrice: String
    let price: String
    let source, title: String
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case discountedPrice = "discounted_price"
        case price
        case source, title
    }
}
struct OrderAddressInfo: Codable {
    let firstName: String?
    let address1, phone, city, zip: String?
    let province, country: String?
    let lastName: String?
    let address2: String
    let latitude, longitude: Double?
    let name, countryCode, provinceCode: String?
    let id, customerID: Int?
    let countryName: String?
    let addressDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case address1, phone, city, zip, province, country
        case lastName = "last_name"
        case address2, latitude, longitude, name
        case countryCode = "country_code"
        case provinceCode = "province_code"
        case id
        case customerID = "customer_id"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}
struct OrdersInfoLineItem: Codable {
    let id: Int
    let adminGraphqlAPIID: String
    let fulfillableQuantity: Int
    let fulfillmentService: String
    let giftCard: Bool
    let grams: Int
    let name, price: String
    let productExists: Bool
    let productID: Int
    let quantity: Int
    let requiresShipping: Bool
    let sku: String
    let taxable: Bool
    let title, totalDiscount: String
    let variantID: Int
    let variantInventoryManagement, variantTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case fulfillableQuantity = "fulfillable_quantity"
        case fulfillmentService = "fulfillment_service"
        case giftCard = "gift_card"
        case grams, name, price
        case productExists = "product_exists"
        case productID = "product_id"
        case quantity
        case requiresShipping = "requires_shipping"
        case sku, taxable, title
        case totalDiscount = "total_discount"
        case variantID = "variant_id"
        case variantInventoryManagement = "variant_inventory_management"
        case variantTitle = "variant_title"
    }
}
