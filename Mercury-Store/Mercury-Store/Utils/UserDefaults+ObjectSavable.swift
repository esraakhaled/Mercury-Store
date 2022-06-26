//
//  UserDefaults+ObjectSavable.swift
//  Mercury-Store
//
//  Created by mac hub on 10/06/2022.
//

import Foundation

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey key: String) throws where Object : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: key)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey key: String, castTo type: Object.Type) throws -> Object where Object : Decodable {
        guard let data = data(forKey: key) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

