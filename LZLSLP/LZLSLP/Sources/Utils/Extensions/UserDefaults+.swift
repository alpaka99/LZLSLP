//
//  UserDefaults+.swift
//  LZLSLP
//
//  Created by user on 8/19/24.
//

import Foundation

extension UserDefaults {
    func save<T: Encodable>(_ data: T) {
        if let encodedData = try? JSONEncoder().encode(data) {
            Self.standard.set(encodedData, forKey: T.key)
        }
    }
    
    func load<T: Decodable>(of type: T.Type) -> T? {
        if let data = Self.standard.data(forKey: T.key), let decodedData = try? JSONDecoder().decode(T.self, from: data) {
            return decodedData
        } else {
            return nil
        }
    }
}


enum UserDefaultsError: Error {
    case saveFailure
    case loadFailure
}
