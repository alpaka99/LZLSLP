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
    
    func requestPostAPI<T: Decodable>(of type: T.Type, router: Router) -> Single<Result<T, Error>> {
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
    
    func requestPostDataAPI<T: Decodable>(of type: T.Type, router: URLRouter, imageArray: [Uploadable]) -> Single<Result<T, Error>> {
        Single.create { observer in
            NetworkManager.shared.uploadDataCall(router: router, dataArray: imageArray, interceptor: PostInterceptor())
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
