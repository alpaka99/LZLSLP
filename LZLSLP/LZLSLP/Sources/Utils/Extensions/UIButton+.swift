//
//  UIButton+.swift
//  LZLSLP
//
//  Created by user on 8/15/24.
//

import UIKit

extension UIButton {
    var config: UIButton.Configuration {
        return self.configuration ?? UIButton.Configuration.plain()
    }
    
    func updateImage(_ systemName: String) {
        let config = self.config
        self.configuration = config.image(systemName: systemName)
    }
    
    func updateTitle(_ title: String) {
        let config = self.config
        self.configuration = config.title(title)
    }
    
    func updateColor(_ color: UIColor) {
        let config = self.config
        self.configuration = config.backgroundColor(color)
    }
    
    func updateForegroundColor(_ color: UIColor) {
        let config = self.config
        self.configuration = config.foregroundColor(color)
    }
}

