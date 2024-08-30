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
        var signUpResponse = PublishSubject<SignUpResponse>()
        var alertMessage = PublishSubject<String>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    private let authRepository = AuthRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.signUpForm
            .flatMap {
                let router = URLRouter.https(.lslp(.auth(.join($0))))
                return self.authRepository.requestAuthAPI(
                    of: SignUpResponse.self,
                    router: router
                )
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let signUpResponse):
                    owner.store.signUpResponse.onNext(signUpResponse)
                case .failure(let error):
                    print("SignUp Error:\(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        store.signUpResponse
            .bind(with: self) { owner, value in
                owner.store.alertMessage.onNext("회원 가입이 완료되었습니다!")
            }
            .disposed(by: disposeBag)
    }
}
