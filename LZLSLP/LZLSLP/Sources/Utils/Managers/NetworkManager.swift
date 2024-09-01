//
//  NetworkManager.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func requestCall(router: Router, interceptor: RequestInterceptor? = nil) -> Single<Result<Data, Error>> {
        Single.create { observer in
            if let urlRequest = router.build() {
                AF.request(urlRequest, interceptor: interceptor)
                    .validate(statusCode: 200..<300)
                    .responseData { result in
                        switch result.result {
                        case .success(let data):
                            print("Data: \(data)")
                            observer(.success(.success(data)))
                        case .failure(let error):
                            print("NetworkManager error: \(error)")
                            switch error {
                            case .createURLRequestFailed:
                                observer(.success(.failure(NetworkError.urlRequestCreateError)))
                            case .responseValidationFailed:
                                observer(.success(.failure(NetworkError.responseStatusCodeError)))
                            default:
                                observer(.success(.failure(NetworkError.networkError)))
                            }
                        }
                    }
            } else {
                observer(.success(.failure(NetworkError.urlRequestCreateError)))
            }
            
            return Disposables.create()
        }
    }
    
    func uploadDataCall(router: URLRouter, dataArray: [Uploadable], interceptor: RequestInterceptor? = nil) -> Single<Result<Data, Error>> {
        return Single.create { observer in
            guard !dataArray.isEmpty else {
                observer(.success(.success(Data())))
                return Disposables.create()
            }
            
            if let urlRequest = router.build() {
                // files라는 parameter 이름으로 이미지 파일들을 올려버림
                
                AF.upload(multipartFormData: { multipartFormData in
                    for data in dataArray {
                        multipartFormData.append(data.data, withName: "files", fileName: "test", mimeType: "image/jpeg")
                    }
                }, with: urlRequest, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseData { result in
                    switch result.result {
                    case .success(let data):
                        observer(.success(.success(data)))
                    case .failure(let error):
//                        print("NetworkManager error: \(error)")
                        observer(.failure(error))
                    }
                }

                
            } else {
                observer(.failure(NetworkError.urlRequestCreateError))
            }
            
            return Disposables.create()
        }
    }
    
    func requestStringResult(router: Router, interceptor: RequestInterceptor? = nil) -> Single<Result<Data, Error>> {
        Single.create { observer in
            if let urlRequest = router.build() {
                AF.request(urlRequest, interceptor: interceptor)
                    .validate(statusCode: 200..<300)
                    .responseString { result in
                        switch result.result {
                        case .success(let str):
                            print("String Result")
                            dump(str)
                        case .failure(let error):
                            print("String Error Result")
                            print(error)
                        }
                    }
            } else {
                observer(.failure(NetworkError.urlRequestCreateError))
            }
            
            return Disposables.create()
        }
    }
}

struct RefreshTokenResponse: Decodable {
    let accessToken: String
}


enum NetworkError: Error {
    case urlRequestCreateError
    case networkError
    case responseStatusCodeError
    case nilDataError
    case decodingFailure
}

enum InterceptorError: Error {
    case tokenURLBuildError
    case tokenFetchError
    case tokenResponseStatusError
    case nilTokenError
    case accessTokenResponseFailureError
}

// MARK: Status Code enum으로 뺴기
enum StatusCode: Int {
    case success = 200
    case forbidden = 403
    case invalidAccessToken = 401
    case invalidRefreshToken = 418
}
