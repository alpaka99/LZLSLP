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
    
    let imageCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.createFlowLayout(numberOfRowsInLine: 1, spacing: 10, heightMultiplier: 1))
        return collectionView
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
        return textField
    }()
    
    let commentTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBlue
        return tableView
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(fireButton)
        self.addSubview(likedUsersLabel)
        self.addSubview(commentTextField)
        self.addSubview(commentTableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        fireButton.snp.makeConstraints { btn in
            btn.size.equalTo(44)
            btn.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        likedUsersLabel.snp.makeConstraints { label in
            label.leading.equalTo(fireButton.snp.trailing)
                .offset(16)
            label.centerY.equalTo(fireButton.snp.centerY)
            label.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        commentTextField.snp.makeConstraints { textField in
            textField.top.equalTo(fireButton.snp.bottom)
                .offset(16)
            textField.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            textField.height.equalTo(44)
        }
        
        commentTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(commentTextField.snp.bottom)
                .offset(16)
            tableView.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
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
