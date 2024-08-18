//
//  UIStackView+.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}
