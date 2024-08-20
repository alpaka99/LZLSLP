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
    
    var data = PublishSubject<Data>()

    
    func requestAuthAPI<T: Decodable>(of type: T.Type, router: Router) -> Single<Result<T, Error>> {
        Single.create { observer in
            NetworkManager.shared.requestCall(router: router)
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            observer(.success(.success(decodedData)))
                        } catch {
                            observer(.success(.failure(error)))
                        }
                    case.failure(let error):
                        observer(.success(.failure(error)))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
        
//        return singleResult
        
//        Single.create { observer in
//             let singleData = NetworkManager.shared.requestCall(router: router)
//                .catch { error in
//                    return Single.just(.failure(error))
//                }
////                .asDriver(onErrorJustReturn: Single.just(Data()))
////                .drive(with: self) { owner, data in
////                    do {
////                        let decodedData = try JSONDecoder().decode(T.self, from: data)
////                        observer(.success(decodedData))
////                    } catch {
////                        observer(.failure(NetworkError.decodingFailure))
////                    }
////                }
//            
//            return Disposables.create()
//        }
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
