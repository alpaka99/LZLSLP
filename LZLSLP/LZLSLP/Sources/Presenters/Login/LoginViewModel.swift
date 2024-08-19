//
//  LoginViewModel.swift
//  LZLSLP
//
//  Created by user on 8/18/24.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel: RxViewModel {
    struct Input: Inputable {
        var loginForm = PublishRelay<(String, String)>()
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
    private let repository = AuthRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.loginForm
            .bind(with: self) { owner, loginForm in
                let email = loginForm.0
                let password = loginForm.1
                
                let router = URLRouter.https(.lslp(.auth(.login(email: email, password: password))))
                owner.repository.router.onNext(router)
            }
            .disposed(by: disposeBag)
    }
}
