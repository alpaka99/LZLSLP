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
    let animationView = {
        let animationView = LottieAnimationView(name: "gasoline_launch")
        return animationView
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        self.addSubview(animationView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        animationView.snp.makeConstraints { view in
            view.center.equalTo(self.safeAreaLayoutGuide)
            
            view.size.equalTo(200)
                .multipliedBy(0.8)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        animationView.play()
    }
}
