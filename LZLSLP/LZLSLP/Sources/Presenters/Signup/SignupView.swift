//
//  SignupView.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import UIKit

import SnapKit

final class SignupView: BaseView {
    let emailTextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        return textField
    }()
    
    let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        return textField
    }()
    
    let nicknameTextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요"
        return textField
    }()
    
    let phoneNumTextField = {
        let textField = UITextField()
        textField.placeholder = "전화번호를 입력해주세요"
        return textField
    }()
    
    lazy var textFieldStack = {[weak self] in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([
            self?.emailTextField,
            self?.passwordTextField,
            self?.nicknameTextField,
            self?.phoneNumTextField,
            self?.birthDayTextField
        ])
        
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let birthDayTextField = {
        let textField = UITextField()
        return textField
    }()
    
    let submitButton = {
        let button = UIButton.Configuration.plain()
            .backgroundColor(.systemBlue)
            .title("회원 가입")
            .cornerStyle(.capsule)
            .build()
        
        button.tintColor = .white
        return button
    }()
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(textFieldStack)
        self.addSubview(submitButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        textFieldStack.snp.makeConstraints { stack in
            stack.width.equalTo(self.safeAreaLayoutGuide.snp.width)
                .multipliedBy(0.8)
            stack.height.equalTo(self.safeAreaLayoutGuide.snp.height)
                .multipliedBy(0.6)
            stack.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        submitButton.snp.makeConstraints { btn in
            btn.top.equalTo(textFieldStack.snp.bottom)
                .offset(20)
            btn.horizontalEdges.equalTo(textFieldStack.snp.horizontalEdges)
            btn.height.equalTo(44)
        }
    }
}
