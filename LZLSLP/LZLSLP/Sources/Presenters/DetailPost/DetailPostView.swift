//
//  DetailView.swift
//  LZLSLP
//
//  Created by user on 8/27/24.
//

import UIKit

import SnapKit

final class DetailPostView: BaseView {
    let fireButton = {
        let button = UIButton.Configuration.plain()
            .image(systemName: "flame")
            .foregroundColor(.black)
            .build()
        
        return button
    }()
    
    let likedUsersLabel = {
        let label = UILabel()
        label.text = "좋아요 누른 유저 목록"
        return label
    }()
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(fireButton)
        self.addSubview(likedUsersLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        fireButton.snp.makeConstraints { btn in
            btn.size.equalTo(44)
            btn.center.equalTo(self.safeAreaLayoutGuide.snp.center)
        }
        
        likedUsersLabel.snp.makeConstraints { label in
            label.leading.equalTo(fireButton.snp.trailing)
                .offset(16)
            label.centerY.equalTo(fireButton.snp.centerY)
            label.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
