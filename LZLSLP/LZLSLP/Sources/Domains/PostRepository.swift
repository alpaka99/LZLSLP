//
//  PostRepository.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import Foundation

import RxSwift

final class PostRepository {
    let disposeBag = DisposeBag()
    
    func postPost<T: Decodable>(of type: T.Type, router: Router) -> Single<Result<T, Error>> {
        Single.create { observer in
            NetworkManager.shared.requestCall(router: router, interceptor: AuthInterceptor())
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
                        print("Error \(error)")
                        observer(.success(.failure(error)))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func postImages<T: Decodable>(of type: T.Type, router: URLRouter, data: [Data]) -> Single<Result<T, Error>> {
        Single.create { observer in
            NetworkManager.shared.requestDataCall(router: router, data: data, interceptor: AuthInterceptor())
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            observer(.success(.success(decodedData)))
                        } catch {
                            observer(.success(.failure(error)))
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: self.disposeBag)
            
            
            return Disposables.create()
        }
    }
}
