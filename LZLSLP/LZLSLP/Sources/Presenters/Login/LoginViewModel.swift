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
        var loginCompleted = PublishSubject<Void>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    private let repository = AuthRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.loginForm
            .bind(with: self) { owner, loginForm in
                let email = loginForm.0
                let password = loginForm.1
                
                print(email, password)
                let router = URLRouter.https(.lslp(.auth(.login(email: email, password: password))))
                
                /*
                 MARK: Memory Leak의 가능성
                 +
                 MARK: 중첩 subscribe 가능성(singUpView + LoginView)
                 */
                owner.repository.requestAuthAPI(
                    of: LoginResponse.self,
                    router: router
                )
                .debug("This is Login")
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let loginResponse):
                            owner.store.loginResponse.accept(loginResponse)
                        case .failure(let error):
                            print("Login error: \(error)")
//                            break // error handling
                        }
                    }
                    .disposed(by: owner.disposeBag)
                    
            }
            .disposed(by: disposeBag)
        
        store.loginResponse
            .bind(with: self) { owner, loginResponse in
                let accessToken = AccessToken(token: loginResponse.accessToken)
                let refreshToken = RefreshToken(token: loginResponse.refreshToken)
                
                UserDefaults.standard.save(accessToken)
                UserDefaults.standard.save(refreshToken)
                
                // 저장 제대로 됐는지 확인
                if let accesToken = UserDefaults.standard.load(of: AccessToken.self), let refreshToken = UserDefaults.standard.load(of: RefreshToken.self) {
                    print("AccessToken: \(accesToken.token)")
                    print("RefreshToken: \(refreshToken.token)")
                    owner.store.loginCompleted.onNext(())
                }
            }
            .disposed(by: disposeBag)
    }
}


struct LoginResponse: Codable {
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

protocol Tokenable: Codable {
    var token: String { get }
}

struct AccessToken: Tokenable {
    let token: String
}

struct RefreshToken: Tokenable {
    let token: String
}
