//
//  CommunityTableViewCell.swift
//  LZLSLP
//
//  Created by user on 8/31/24.
//

import UIKit

import SnapKit

final class CommunityTableViewCell: BaseTableViewCell {
    lazy var gradient = UIImage.gradientImage(bounds: self.bounds, colors: [.systemRed, .systemPurple, .systemOrange ,.systemPink])
    lazy var gradientColor = UIColor(patternImage: gradient)
    
    let thumbnailImage = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "danger")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.randomColor()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let title = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    let content = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    let likeImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "flame")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    let likeNumber = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    lazy var likeStack = { [weak self] in
        guard let cell = self else { return UIStackView() }
        let stack = UIStackView(arrangedSubviews: [cell.likeImage, cell.likeNumber])
        stack.axis = .vertical
        return stack
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(title)
        contentView.addSubview(content)
        contentView.addSubview(likeStack)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        thumbnailImage.snp.makeConstraints { img in
            img.leading.verticalEdges.equalTo(contentView)
                .inset(16)
            img.width.equalTo(thumbnailImage.snp.height)
        }
        
        title.snp.makeConstraints { label in
            label.leading.equalTo(thumbnailImage.snp.trailing)
                .offset(16)
            label.top.equalTo(thumbnailImage.snp.top)
            label.trailing.equalTo(likeImage)
                .inset(8)
        }
        
        content.snp.makeConstraints { label in
            label.leading.equalTo(thumbnailImage.snp.trailing)
                .offset(16)
            label.bottom.equalTo(thumbnailImage.snp.bottom)
            label.trailing.equalTo(likeStack)
                .inset(8)
        }
        
        likeImage.snp.makeConstraints { img in
            img.size.equalTo(32)
        }
        
        likeStack.snp.makeConstraints { stack in
            stack.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
                .inset(8)
            stack.trailing.equalTo(contentView)
                .inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImage.image = UIImage(named: "thumbnail")
        likeImage.tintColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        contentView.layer.borderColor = gradientColor.cgColor
        contentView.layer.borderWidth = 2
        
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        thumbnailImage.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        
    }
}

