//
//  DetailImageCell.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import UIKit

import SnapKit

final class DetailImageCell: BaseCollectionViewCell {
    let imageView = {
        let view = UIImageView()
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(imageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}
