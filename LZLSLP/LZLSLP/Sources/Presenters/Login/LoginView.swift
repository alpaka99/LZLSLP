//
//  LoginView.swift
//  LZLSLP
//
//  Created by user on 8/18/24.
//

import UIKit

import SnapKit

final class LoginView: BaseView {
    let background = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.15)
        return view
    }()
    
    let logoView = LogoView(fontSize: 50, weight: .bold, logoColor: .systemRed)
    
    let emailTextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        textField.isSecureTextEntry = true
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
            .font(ofSize: 24, weight: .bold)
            .foregroundColor(.systemRed)
            .backgroundColor(.black)
            .cornerStyle(.capsule)
            .build()
        
        return button
    }()
    
    let signUpButton = {
        let button = UIButton.Configuration.plain()
            .title("아직 회원이 아니신가요?")
            .foregroundColor(.systemRed)
            .build()
        
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(background)
        
        self.addSubview(logoView)
        self.addSubview(textFieldStack)
        self.addSubview(submitButton)
        self.addSubview(signUpButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        background.snp.makeConstraints { view in
            view.edges.equalTo(self)
        }
        
        
        logoView.snp.makeConstraints { view in
            view.centerX.equalTo(self.safeAreaLayoutGuide)
            view.centerY.equalTo(self.safeAreaLayoutGuide)
                .multipliedBy(0.5)
        }
        
        emailTextField.snp.makeConstraints { textField in
            textField.height.equalTo(50)
            textField.horizontalEdges.equalTo(textFieldStack.snp.horizontalEdges)
        }
        
        passwordTextField.snp.makeConstraints { textField in
            textField.height.equalTo(50)
            textField.horizontalEdges.equalTo(textFieldStack.snp.horizontalEdges)
        }
        
        textFieldStack.snp.makeConstraints { stack in
            stack.center.equalTo(self.safeAreaLayoutGuide)
            stack.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(40)
        }
        
        submitButton.snp.makeConstraints { btn in
            btn.top.equalTo(textFieldStack.snp.bottom)
                .offset(20)
            btn.centerX.equalTo(self.safeAreaLayoutGuide)
            
            btn.horizontalEdges.equalTo(textFieldStack.snp.horizontalEdges)
        }
        
        signUpButton.snp.makeConstraints { btn in
            btn.centerX.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
