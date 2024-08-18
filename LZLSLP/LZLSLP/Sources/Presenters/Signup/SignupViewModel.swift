//
//  SignupViewModel.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

import RxSwift

final class SignupViewModel: RxViewModel {
    struct Input: Inputable {
        var signUpForm = PublishSubject<SignUpForm>()
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
    let authRepository = AuthRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.signUpForm
            .bind(with: self) { owner, signUpForm in
                let router = URLRouter.https(.lslp(.auth(.join(signUpForm))))
                owner.authRepository.router.onNext(router)
            }
            .disposed(by: disposeBag)
    }
}
