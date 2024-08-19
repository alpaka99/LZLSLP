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
        var loginResponse = PublishRelay<LoginResponse>()
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
                
                /*
                 MARK: Memory Leak의 가능성
                 */
                owner.repository.requestAuthAPI(of: LoginResponse.self, router: router)
                    .subscribe(with: self) { owner, data in
                        owner.store.loginResponse
                            .accept(data)
                    }
                    .disposed(by: owner.disposeBag)
                    
            }
            .disposed(by: disposeBag)
        
        store.loginResponse
            .bind(with: self) { owner, data in
                dump(data)
            }
            .disposed(by: disposeBag)
    }
}


struct LoginResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case accessToken
        case refreshToken
    }
}
