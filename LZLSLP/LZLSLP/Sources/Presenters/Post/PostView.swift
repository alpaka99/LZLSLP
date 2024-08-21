//
//  PostView.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit

import SnapKit

final class PostView: BaseView {
    let titleTextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let imagePickerButton = {
        let button = UIButton.Configuration.plain()
            .title("이미지 추가")
            .foregroundColor(.white)
            .backgroundColor(.systemRed)
            .cornerStyle(.medium)
            .build()
        return button
    }()
    
    let contentView = {
        let textView = UITextView()
        textView.textContainer.maximumNumberOfLines = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()
    
    
    let submitButton = {
        let button = UIButton.Configuration.plain()
            .title("글쓰기")
            .foregroundColor(.white)
            .backgroundColor(.systemBlue)
            .cornerStyle(.capsule)
            .build()
        
        return button
    }()
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(titleTextField)
        self.addSubview(imagePickerButton)
        self.addSubview(contentView)
        self.addSubview(submitButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleTextField.snp.makeConstraints { textField in
            textField.top.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            textField.leading.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
        }
        
        imagePickerButton.snp.makeConstraints { btn in
            btn.top.equalTo(titleTextField.snp.top)
            btn.leading.equalTo(titleTextField.snp.trailing)
                .offset(16)
            btn.trailing.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        
        contentView.snp.makeConstraints { textView in
            textView.top.equalTo(titleTextField.snp.bottom)
                .offset(20)
            textView.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        
        submitButton.snp.makeConstraints { btn in
            btn.top.equalTo(contentView.snp.bottom)
                .offset(16)
            btn.centerX.equalTo(self.safeAreaLayoutGuide)
            btn.bottom.equalTo(self.safeAreaLayoutGuide)
            btn.height.equalTo(44)
        }
    }
}
