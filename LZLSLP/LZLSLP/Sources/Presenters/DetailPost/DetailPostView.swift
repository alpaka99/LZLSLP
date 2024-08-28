//
//  DetailView.swift
//  LZLSLP
//
//  Created by user on 8/27/24.
//

import UIKit

import SnapKit

final class DetailPostView: BaseView {
    let scrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let imageCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.createFlowLayout(numberOfRowsInLine: 1, spacing: 10, heightMultiplier: 1))
        return collectionView
    }()
    
    let contentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.backgroundColor = . systemBlue
        return label
    }()
    
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
    
    let commentTextField = {
        let textField = UITextField()
        textField.placeholder = "댓글 추가"
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    let commentTableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(fireButton)
        contentView.addSubview(likedUsersLabel)
        contentView.addSubview(commentTextField)
        contentView.addSubview(commentTableView)
        
        scrollView.addSubview(contentView)
        
        self.addSubview(scrollView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        contentView.snp.makeConstraints { view in
            view.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            view.verticalEdges.equalTo(scrollView.contentLayoutGuide)
        }
        
        imageCollectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(contentView)
                .offset(16)
            collectionView.centerX.equalTo(contentView)
        }
        
        contentLabel.snp.makeConstraints { label in
            label.top.equalTo(imageCollectionView.snp.bottom)
                .offset(16)
            label.horizontalEdges.equalTo(contentView)
                .inset(16)
        }
        
        fireButton.snp.makeConstraints { btn in
            btn.size.equalTo(44)
            btn.top.equalTo(contentLabel.snp.bottom)
                .offset(16)
            btn.centerX.equalTo(contentView)
        }
        
        likedUsersLabel.snp.makeConstraints { label in
            label.top.equalTo(fireButton.snp.bottom)
                .offset(16)
            label.horizontalEdges.equalTo(contentView)
                .inset(16)
        }
        
        commentTextField.snp.makeConstraints { textField in
            textField.top.equalTo(likedUsersLabel.snp.bottom)
                .offset(16)
            textField.horizontalEdges.equalTo(contentView)
                .inset(16)
            textField.height.equalTo(44)
        }
        
        commentTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(commentTextField.snp.bottom)
                .offset(16)
            tableView.height.equalTo(500)
            tableView.horizontalEdges.bottom.equalTo(contentView)
        }
        
        scrollView.snp.makeConstraints { scrollView in
            scrollView.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension UICollectionViewLayout {
    static func createFlowLayout(numberOfRowsInLine: CGFloat, spacing: CGFloat, heightMultiplier: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        
        let lengthOfALine = ScreenSize.width - (spacing * CGFloat(2 + numberOfRowsInLine - 1))
        let length = lengthOfALine / numberOfRowsInLine
        
        flowLayout.itemSize = CGSize(
            width: length,
            height: length * heightMultiplier
        )
        
        return flowLayout
    }
}
