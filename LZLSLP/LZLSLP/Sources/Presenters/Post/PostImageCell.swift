//
//  PostImageCell.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import UIKit

import SnapKit

final class PostImageCell: BaseCollectionViewCell {
    let imageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let deleteButton = {
        let button = UIButton.Configuration.plain()
            .image(systemName: "xmark")
            .imageSize(size: 8)
            .foregroundColor(.systemRed)
            .backgroundColor(.black)
            .cornerStyle(.capsule)
            .build()
        
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(imageView)
        addSubview(deleteButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        deleteButton.snp.makeConstraints { btn in
            btn.size.equalTo(12)
            btn.top.trailing.equalTo(self)
                .inset(8)
        }
    }
}
