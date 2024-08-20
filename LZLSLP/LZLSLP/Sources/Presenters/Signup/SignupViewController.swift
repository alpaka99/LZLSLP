//
//  SignupViewController.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SignupViewController: BaseViewController<SignupView, SignupViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Signup ViewController"
    }
    
    override func configureBind() {
        super.configureBind()
        
        baseView.submitButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    baseView.emailTextField.rx.text.orEmpty,
                    baseView.passwordTextField.rx.text.orEmpty,
                    baseView.nicknameTextField.rx.text.orEmpty
                )
            )
            .bind(with: self) { owner, value in
                let email = value.0
                let password = value.1
                let nick = value.2
                
                print("This >>>", email, password, nick)
                
                let signUpForm = SignUpForm(
                    email: email,
                    password: password,
                    nick: nick,
                    phoneNum: nil,
                    birthDay: nil
                )
                
                owner.viewModel.store.signUpForm
                    .onNext(signUpForm)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.store.singUpResponse
            .bind(with: self) { owner, response in
                dump(response)
            }
            .disposed(by: disposeBag)
    }
}
