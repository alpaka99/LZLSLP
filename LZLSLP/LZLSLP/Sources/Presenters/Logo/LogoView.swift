//
//  LogoView.swift
//  LZLSLP
//
//  Created by user on 8/31/24.
//

import UIKit

import SnapKit

final class LogoView: BaseView {
    let fontSize: CGFloat
    let weight: UIFont.Weight
    let logoColor: UIColor
    
    init(fontSize: CGFloat, weight: UIFont.Weight, logoColor: UIColor) {
        self.fontSize = fontSize
        self.weight = weight
        self.logoColor = logoColor
        super.init(frame: .zero)
    }
    
    lazy var logoImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "flame.fill")
        imageView.tintColor = logoColor
        return imageView
    }()
    
    lazy var logoLabel = {
        let label = UILabel()
        label.text = "가솔린"
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        return label
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(logoImage)
        self.addSubview(logoLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        logoLabel.snp.makeConstraints { label in
            label.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            label.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
        
        logoImage.snp.makeConstraints { image in
            image.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            image.trailing.equalTo(logoLabel.snp.leading)
                .offset(-8)
            image.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            image.width.equalTo(logoImage.snp.height)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.backgroundColor = .clear
    }
}
