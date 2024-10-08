//
//  UIImage+.swift
//  LZLSLP
//
//  Created by user on 8/31/24.
//

import Foundation
import UIKit

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = colors.map(\.cgColor)

            // This makes it left to right, default is top to bottom
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

            let renderer = UIGraphicsImageRenderer(bounds: bounds)

            return renderer.image { ctx in
                gradientLayer.render(in: ctx.cgContext)
            }
        }
}
