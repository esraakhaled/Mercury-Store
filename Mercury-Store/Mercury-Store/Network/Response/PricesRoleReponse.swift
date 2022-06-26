//
//  PricesRoleReponse.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 11/06/2022.
//

import Foundation

struct PricesRoleResponse: Codable {
    let priceRules: [PriceRule]

    enum CodingKeys: String, CodingKey {
        case priceRules = "price_rules"
    }
}

struct SinglePriceRoleResponse: Codable{
    let priceRule: PriceRule

    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
    }
}
// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int
    let valueType, value, customerSelection, targetType: String
    let targetSelection, allocationMethod: String
    let allocationLimit: Int?
    let oncePerCustomer: Bool
    let usageLimit: Int?
    let startsAt: Date
    let endsAt: Date?
    let createdAt, updatedAt: Date
    let entitledProductIDS, entitledVariantIDS, entitledCollectionIDS, entitledCountryIDS: [Int?]
    let prerequisiteProductIDS, prerequisiteVariantIDS, prerequisiteCollectionIDS, customerSegmentPrerequisiteIDS: [Int?]
    let prerequisiteCustomerIDS: [Int?]
    let title, adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case allocationLimit = "allocation_limit"
        case oncePerCustomer = "once_per_customer"
        case usageLimit = "usage_limit"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case entitledProductIDS = "entitled_product_ids"
        case entitledVariantIDS = "entitled_variant_ids"
        case entitledCollectionIDS = "entitled_collection_ids"
        case entitledCountryIDS = "entitled_country_ids"
        case prerequisiteProductIDS = "prerequisite_product_ids"
        case prerequisiteVariantIDS = "prerequisite_variant_ids"
        case prerequisiteCollectionIDS = "prerequisite_collection_ids"
        case customerSegmentPrerequisiteIDS = "customer_segment_prerequisite_ids"
        case prerequisiteCustomerIDS = "prerequisite_customer_ids"
        case title
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
    init(){
        id = 0
        valueType = ""
        value = ""
        customerSelection = ""
        targetType = ""
        targetSelection = ""
        allocationMethod = ""
        allocationLimit = 0
        oncePerCustomer = false
        usageLimit = 0
        startsAt = Date()
        endsAt = Date()
        createdAt = Date()
        updatedAt =  Date()
        entitledProductIDS = []
        entitledVariantIDS = []
        entitledCollectionIDS = []
        entitledCountryIDS =  []
        prerequisiteProductIDS = []
        prerequisiteVariantIDS = []
        prerequisiteCollectionIDS = []
        customerSegmentPrerequisiteIDS = []
        prerequisiteCustomerIDS = []
        title = ""
        adminGraphqlAPIID = ""
    }
}
