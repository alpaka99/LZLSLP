//
//  Color.swift
//  LZLSLP
//
//  Created by user on 8/31/24.
//

import Foundation

import UIKit

enum Color {
    case background
    
    var color: UIColor {
        switch self {
        case .background:
            return .lightGray
        }
    }
}
