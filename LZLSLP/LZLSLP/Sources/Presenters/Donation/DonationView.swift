//
//  DonationView.swift
//  LZLSLP
//
//  Created by user on 9/2/24.
//

import UIKit

import SnapKit
import Lottie

final class DonationView: BaseView {
    lazy var gradientImage = UIImage.gradientImage(bounds: coffeeAnimationView.bounds, colors: [.systemRed, .systemPurple, .systemOrange, .systemYellow, .systemPink])
    lazy var gradientColor = UIColor.init(patternImage: gradientImage)
    
    let title = {
        let label = UILabel()
        label.text = "개발자의 열정에 기름(커피 한잔) 부어주기"
        label.textAlignment = .center
        return label
    }()
    
    lazy var coffeeAnimationView = {
        let animationView = LottieAnimationView(name: "gasoline_coffee")
        animationView.addGestureRecognizer(coffeeTapRecognizer)
        animationView.play()
        animationView.loopMode = .loop
        return animationView
    }()
    
    let coffeeTapRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer()
        return tapGestureRecognizer
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(title)
        self.addSubview(coffeeAnimationView)
    }
    
    
    override func configureLayout() {
        super.configureLayout()
        
        title.snp.makeConstraints { label in
            label.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        coffeeAnimationView.snp.makeConstraints { animationView in
            animationView.size.equalTo(self.safeAreaLayoutGuide.snp.width)
                .multipliedBy(0.6)
            
            
            animationView.center.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        coffeeAnimationView.layer.cornerRadius = coffeeAnimationView.frame.width / 2
        
        coffeeAnimationView.layer.borderColor = gradientColor.cgColor
        coffeeAnimationView.layer.borderWidth = 8
    }
}
