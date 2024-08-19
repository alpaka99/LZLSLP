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
        var singUpResponse = PublishSubject<SignUpResponse>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    private let authRepository = AuthRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.signUpForm
            .bind(with: self) { owner, signUpForm in
                let router = URLRouter.https(.lslp(.auth(.join(signUpForm))))
//                owner.authRepository.router.onNext(router)
                owner.authRepository.requestAuthAPI(
                    of: SignUpResponse.self,
                    router: router
                )
                    .subscribe(with: self) { owner, result in
                        print(result)
                        switch result {
                        case .success(let signUpResponse):
                            dump(signUpResponse)
                            owner.store.singUpResponse.onNext(signUpResponse)
                        case .failure(let error):
                            print("SignUp Error:\(error)")
                        }
                    }
                    .disposed(by: owner.disposeBag)
                    
            }
            .disposed(by: disposeBag)
    }
}
