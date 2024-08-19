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
    
    func requestAuthAPI<T: Decodable>(of type: T.Type, router: Router) -> Single<T> {
        Single.create { observer in
             let singleData = NetworkManager.shared.requestCall(router: router)
                .asDriver(onErrorJustReturn: Data())
                .drive(with: self) { owner, data in
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        observer(.success(decodedData))
                    } catch {
                        observer(.failure(NetworkError.decodingFailure))
                    }
                }
            
            return Disposables.create()
        }
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
