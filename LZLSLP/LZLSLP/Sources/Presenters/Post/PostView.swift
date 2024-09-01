//
//  PostView.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit

import SnapKit

final class PostView: BaseView {
    let imagePickerButton = {
        let button = UIButton.Configuration.plain()
            .image(systemName: "photo.stack.fill")
            .foregroundColor(.white)
            .backgroundColor(.systemRed)
            .cornerStyle(.medium)
            .build()
        return button
    }()
    
    let imageCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.createFlowLayout(
            numberOfRowsInLine: 1,
            spacing: 10,
            width: 80,
            heightMultiplier: 1)
        )
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let titleTextField = {
        let textField = UITextField()
        textField.placeholder = "글 제목"
        return textField
    }()
    
    let divider = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let contentView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    
    let submitButton = {
        let button = UIButton.Configuration.plain()
            .title("작성 완료")
            .font(ofSize: 24, weight: .heavy)
            .foregroundColor(.black)
            .backgroundColor(.red)
            .cornerStyle(.medium)
            .build()
        
        return button
    }()
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(imagePickerButton)
        self.addSubview(imageCollectionView)
        self.addSubview(titleTextField)
        self.addSubview(divider)
        self.addSubview(contentView)
        self.addSubview(submitButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imagePickerButton.snp.makeConstraints { btn in
            btn.top.equalTo(self.safeAreaLayoutGuide)
                .offset(20)
            btn.leading.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
            btn.size.equalTo(80)
        }
        
        imageCollectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(imagePickerButton)
            collectionView.leading.equalTo(imagePickerButton.snp.trailing)
                .offset(20)
            collectionView.trailing.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            collectionView.height.equalTo(80)
        }
        
        titleTextField.snp.makeConstraints { textField in
            textField.top.equalTo(imagePickerButton.snp.bottom)
                .offset(16)
            textField.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            textField.height.equalTo(50)
        }
        
        divider.snp.makeConstraints { view in
            view.top.equalTo(titleTextField.snp.bottom)
                .offset(8)
            view.horizontalEdges.equalTo(titleTextField)
            view.height.equalTo(1)
        }
        
        
        contentView.snp.makeConstraints { textView in
            textView.top.equalTo(divider.snp.bottom)
                .offset(20)
            textView.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        
        submitButton.snp.makeConstraints { btn in
            btn.top.equalTo(contentView.snp.bottom)
                .offset(16)
            btn.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(50)
            btn.bottom.equalTo(self.safeAreaLayoutGuide)
            btn.height.equalTo(44)
        }
    }
}


