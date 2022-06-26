//
//  CategoryProductsResponse.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 27/05/2022.
//

import Foundation



// MARK: - Welcome
struct ProductsCategory: Codable {
    let products: [Product]
}
struct productElement:Codable{
    let productElement:Product
}
// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, bodyHTML, vendor: String
    let productType: String
    let createdAt: Date
    let handle: String
    let updatedAt, publishedAt: Date
    let templateSuffix: String?
    let status: Status
    let publishedScope: PublishedScope
    let tags, adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [Option]
    let images: [ProductImage]
    let image: ProductImage

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case status
        case publishedScope = "published_scope"
        case tags
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

// MARK: - Image
struct ProductImage: Codable {
    let id, productID, position: Int
    let createdAt, updatedAt: Date
    let alt: String?
    let width, height: Int
    let src: String
    let variantIDS: [Int]
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alt, width, height, src
        case variantIDS = "variant_ids"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: Name
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

enum Name: String, Codable {
    case color = "Color"
    case size = "Size"
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let inventoryPolicy: InventoryPolicy
    let compareAtPrice: String?
    let fulfillmentService: FulfillmentService
    let inventoryManagement: InventoryManagement
    let option1: String
    let option2: Option2
    let option3: String?
    let createdAt, updatedAt: Date
    let taxable: Bool
    let barcode: String?
    let grams: Int
    let imageID: Int?
    let weight: Int
    let weightUnit: WeightUnit
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2, option3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, barcode, grams
        case imageID = "image_id"
        case weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

enum FulfillmentService: String, Codable {
    case manual = "manual"
}

enum InventoryManagement: String, Codable {
    case shopify = "shopify"
}

enum InventoryPolicy: String, Codable {
    case deny = "deny"
}

enum Option2: String, Codable {
    case beige = "beige"
    case black = "black"
    case blue = "blue"
    case burgandy = "burgandy"
    case gray = "gray"
    case lightBrown = "light_brown"
    case red = "red"
    case white = "white"
    case yellow = "yellow"
}

enum WeightUnit: String, Codable {
    case kg = "kg"
}

extension Variant: Equatable {}
