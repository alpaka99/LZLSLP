//
//  AuthRepository.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

import RxCocoa
import RxSwift

final class AuthRepository {
    let disposeBag = DisposeBag()
    
    var router = PublishSubject<Router>()
    var data = PublishSubject<Data>()
    
    init() {
        configureBind()
    }
    
    func configureBind() {
        router
            .flatMap { router in
                NetworkManager.shared.requestCall(router: router)
            }
            .debug()
            .asDriver(onErrorJustReturn: Data())
            .drive(with: self) { owner, data in
                let convertedData = try! JSONDecoder().decode(SignUpResponse.self, from: data)
                print(convertedData)
            }
            .disposed(by: disposeBag)
    }
}

struct SignUpResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
    }
}
