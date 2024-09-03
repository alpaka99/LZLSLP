//
//  PaymentRepository.swift
//  LZLSLP
//
//  Created by user on 9/2/24.
//

import Foundation

import RxSwift

final class PaymentRepository {
    let disposeBag = DisposeBag()
    
    func requestPaymentValidation<T: Decodable>(of type: T.Type, router: Router) -> Single<Result<T, Error>> {
        Single.create { observer in
            NetworkManager.shared.requestCall(router: router, interceptor: PostInterceptor())
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            observer(.success(.success(decodedData)))
                        } catch {
                            print("Catched: \(error)")
                            observer(.success(.failure(error)))
                        }
                    case.failure(let error):
                        print("Error \(error)")
                        observer(.success(.failure(error)))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
