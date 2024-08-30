//
//  LaunchView.swift
//  LZLSLP
//
//  Created by user on 8/30/24.
//

import UIKit

import SnapKit
import Lottie

final class LaunchView: BaseView {
    let logoAnimation = {
        let animationView = LottieAnimationView(name: "gasoline_launch")
        return animationView
    }()
    
//    let textAnimation = {
//        let animationView = LottieAnimationView(name: "gasoline_loading")
//        return animationView
//    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(logoAnimation)
//        self.addSubview(textAnimation)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        logoAnimation.snp.makeConstraints { view in
            view.center.equalTo(self.safeAreaLayoutGuide)
            view.size.equalTo(self.safeAreaLayoutGuide.snp.width)
                .multipliedBy(0.8)
        }
        
//        textAnimation.snp.makeConstraints { view in
//            view.top.equalTo(logoAnimation.snp.bottom)
//                .offset(20)
//            view.horizontalEdges.equalTo(logoAnimation.snp.horizontalEdges)
//            view.height.equalTo(100)
//        }
    }
    
    override func configureUI() {
        super.configureUI()
        self.backgroundColor = .black
        logoAnimation.play()
//        textAnimation.play()
    }
}
