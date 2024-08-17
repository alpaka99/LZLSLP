//
//  NetworkManager.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func requestCall(router: Router) -> Single<Data> {
        Single.create { observer in
            if let urlRequest = router.build() {
                URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard error == nil else {
                        observer(.failure(NetworkError.networkError))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                        observer(.failure(NetworkError.responseStatusCodeError))
                        return
                    }

                    guard let data = data else { 
                        observer(.failure(NetworkError.nilDataError))
                        return
                    }
                    
                    observer(.success(data))
                }
                .resume()
            } else {
                observer(.failure(NetworkError.urlRequestCreateError))
            }
            
            return Disposables.create()
        }
    }
}


enum NetworkError: Error {
    case urlRequestCreateError
    case networkError
    case responseStatusCodeError
    case nilDataError
}
