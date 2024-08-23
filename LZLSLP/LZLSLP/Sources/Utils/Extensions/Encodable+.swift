//
//  Encodable+.swift
//  LZLSLP
//
//  Created by user on 8/19/24.
//

import Foundation

extension Encodable {
    static var key: String {
        return String(describing: self)
    }
}
