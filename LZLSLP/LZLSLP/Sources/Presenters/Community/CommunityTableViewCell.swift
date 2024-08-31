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
        
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(content)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        image.snp.makeConstraints { img in
            img.verticalEdges.equalTo(contentView)
                .inset(8)
            img.leading.equalTo(contentView)
                .inset(8)
            img.width.equalTo(image.snp.height)
        }
        
        title.snp.makeConstraints { label in
            label.leading.equalTo(image.snp.trailing)
                .offset(16)
            label.top.equalTo(image.snp.top)
            label.trailing.equalTo(contentView)
                .inset(8)
        }
        
        content.snp.makeConstraints { label in
            label.leading.equalTo(image.snp.trailing)
                .offset(16)
            label.bottom.equalTo(image.snp.bottom)
            label.trailing.equalTo(contentView)
                .inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image.image = UIImage(systemName: "flame.fill")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        contentView.layer.borderColor = UIColor.systemOrange.cgColor
        contentView.layer.borderWidth = 1
        
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        image.layer.cornerRadius = 8
    }
}

