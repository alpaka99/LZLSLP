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
    
    func requestAuthAPI<T: Decodable>(of type: T.Type, router: Router) -> Single<Result<T, Error>> {
        Single.create { observer in
            NetworkManager.shared.requestCall(router: router)
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            print("1")
                            observer(.success(.success(decodedData)))
                        } catch {
                            print("2")
                            observer(.success(.failure(error)))
                        }
                    case.failure(let error):
                        print("3")
                        observer(.success(.failure(error)))
                    }
                }
                .disposed(by: self.disposeBag)
            
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
