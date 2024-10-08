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
            .flatMap {
                let email = $0.0
                let password = $0.1
                return self.repository.requestAuthAPI(of: LoginResponse.self, router: URLRouter.https(.lslp(.auth(.login(email: email, password: password)))))
                
            }
            .bind(with: self, onNext: { owner, response in
                print("Reached Here")
                switch response {
                case .success(let data):
                    owner.store.loginResponse.accept(data)
                case .failure(let error):
                    print("Login error: \(error)")
                }
            })
            .disposed(by: disposeBag) 
        
        store.loginResponse
            .bind(with: self) { owner, loginResponse in
                let accessToken = AccessToken(token: loginResponse.accessToken)
                let refreshToken = RefreshToken(token: loginResponse.refreshToken)
                let userId = UserInfo(userId: loginResponse.userId)
                
                UserDefaults.standard.save(accessToken)
                UserDefaults.standard.save(refreshToken)
                UserDefaults.standard.save(userId)
                
                print(accessToken)
                print(refreshToken)
                
                // 저장 제대로 됐는지 확인
                if let _ = UserDefaults.standard.load(of: AccessToken.self), let _ = UserDefaults.standard.load(of: RefreshToken.self) {
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

struct UserInfo: Codable {
    let userId: String
}
