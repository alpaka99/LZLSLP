//
//  CommunityTableViewCell.swift
//  LZLSLP
//
//  Created by user on 8/31/24.
//

import UIKit

import SnapKit

final class CommunityTableViewCell: BaseTableViewCell {
    let image = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "flame.fill")
        imageView.tintColor = UIColor.randomColor()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let title = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let content = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(image)
        self.addSubview(title)
        self.addSubview(content)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        image.snp.makeConstraints { img in
            img.verticalEdges.equalTo(self)
                .inset(8)
            img.leading.equalTo(self)
                .inset(8)
            img.width.equalTo(image.snp.height)
        }
        
        title.snp.makeConstraints { label in
            label.leading.equalTo(image.snp.trailing)
                .offset(16)
            label.top.equalTo(self)
                .offset(16)
            label.trailing.equalTo(self)
                .inset(8)
        }
        
        content.snp.makeConstraints { label in
            label.leading.equalTo(image.snp.trailing)
                .offset(16)
            label.bottom.equalTo(self)
                .offset(-16)
            label.trailing.equalTo(self)
                .inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image.image = UIImage(systemName: "flame.fill")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        image.layer.cornerRadius = 8
    }
}

