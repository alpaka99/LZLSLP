//
//  LoginView.swift
//  LZLSLP
//
//  Created by user on 8/18/24.
//

import UIKit

import SnapKit

final class LoginView: BaseView {
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
    
    lazy var textFieldStack = {[weak self] in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([
            self?.emailTextField,
            self?.passwordTextField
        ])
        
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let submitButton = {
        let button = UIButton.Configuration.plain()
            .title("로그인")
            .foregroundColor(.white)
            .backgroundColor(.systemBlue)
            .cornerStyle(.capsule)
            .build()
        
        return button
    }()
    
    let signUpButton = {
        let button = UIButton.Configuration.plain()
            .title("아직 회원이 아니신가요?")
            .foregroundColor(.systemBlue)
            .build()
        
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(textFieldStack)
        self.addSubview(submitButton)
        self.addSubview(signUpButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        textFieldStack.snp.makeConstraints { textField in
            textField.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        submitButton.snp.makeConstraints { btn in
            btn.top.equalTo(textFieldStack.snp.bottom)
                .offset(20)
            btn.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        signUpButton.snp.makeConstraints { btn in
            btn.centerX.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
