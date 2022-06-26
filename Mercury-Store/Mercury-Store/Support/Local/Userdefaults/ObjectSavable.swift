//
//  ObjectSavable.swift
//  Mercury-Store
//
//  Created by mac hub on 10/06/2022.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey key: String) throws where Object: Encodable
    func getObject<Object>(forKey key: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given key"
    
    var errorDescription: String? {
        rawValue
    }
}
