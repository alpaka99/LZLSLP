//
//  LoginViewController.swift
//  LZLSLP
//
//  Created by user on 8/18/24.
//

import UIKit

import RxSwift

final class LoginViewController: BaseViewController<LoginView, LoginViewModel> {
    
    override func configureBind() {
        super.configureBind()
        
        baseView.submitButton.rx.tap
            .withLatestFrom(Observable.combineLatest(
                baseView.emailTextField.rx.text.orEmpty,
                baseView.passwordTextField.rx.text.orEmpty)
            )
            .bind(with: self) { owner, value in
                let email = value.0
                let password = value.1
                print(email, password)
                
                owner.viewModel.store.loginForm.accept((email, password))
            }
            .disposed(by: disposeBag)
    }
}
