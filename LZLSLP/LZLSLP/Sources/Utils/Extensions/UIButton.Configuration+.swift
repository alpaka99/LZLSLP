//
//  UIButton.Configuration+.swift
//  LZLSLP
//
//  Created by user on 8/15/24.
//

import UIKit

extension UIButton.Configuration {
    func image(named: String) -> Self {
        var config = self
        config.image = UIImage(named: named)
        return config
    }
    
    func image(systemName: String) -> Self {
        var config = self
        config.image = UIImage(systemName: systemName)
        return config
    }
    
    func imageSize(size: CGFloat) -> Self {
        var config = self
        if let _ = config.image {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: size)
            config.preferredSymbolConfigurationForImage = imageConfig
        }
        return config
    }
    
    func imageColor(color: UIColor) -> Self {
        var config = self
        let transformer = UIConfigurationColorTransformer { _ in
            return color
        }
        
        config.imageColorTransformer = transformer
        return config
    }
    
    func title(_ title: String) -> Self {
        var config = self
        config.attributedTitle = AttributedString(stringLiteral: title)
        return config
    }
    
    func foregroundColor(_ color: UIColor) -> Self {
        var config = self
        config.baseForegroundColor = color
        return config
    }
    
    func backgroundColor(_ color: UIColor) -> Self {
        var config = self
        config.background.backgroundColor = color
        return config
    }
    
    func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> Self {
        var config = self
        let transformer = UIConfigurationTextAttributesTransformer { oldValue in
            var newValue = oldValue
            newValue.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
            return newValue
        }
        
        config.titleTextAttributesTransformer = transformer
        return config
    }
    
    func imagePadding(_ space: CGFloat) -> Self {
        var config = self
        config.imagePadding = space
        return config
    }
    
    func cornerStyle(_ cornerStyle: Self.CornerStyle) -> Self {
        var config = self
        config.cornerStyle = cornerStyle
        return config
    }
    
    func build() -> UIButton {
        let button = UIButton()
        button.configuration = self
        return button
    }
}
