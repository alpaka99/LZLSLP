//
//  Reusable.swift
//  LZLSLP
//
//  Created by user on 8/31/24.
//

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier:  String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
extension UICollectionViewCell: Reusable { }
