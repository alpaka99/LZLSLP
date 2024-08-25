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
                    .responseString { result in
                        switch result.result {
                        case .success(let str):
                            print(str)
                        case .failure(let error):
                            print(error)
                        }
                    }
//                    .responseData { result in
//                        switch result.result {
//                        case .success(let data):
//                            observer(.success(.success(data)))
//                        case .failure(let error):
//                            print("NetworkManager error: \(error)")
//                            switch error {
//                            case .createURLRequestFailed:
//                                observer(.failure(NetworkError.urlRequestCreateError))
//                            case .responseValidationFailed:
//                                observer(.failure(NetworkError.responseStatusCodeError))
//                            default:
//                                observer(.failure(NetworkError.networkError))
//                            }
//                        }
//                    }
            } else {
                observer(.failure(NetworkError.urlRequestCreateError))
            }
            
            return Disposables.create()
        }
    }
    
    func requestDataCall(router: URLRouter, dataArray: [Uploadable], interceptor: RequestInterceptor? = nil) -> Single<Result<Data, Error>> {
        return Single.create { observer in
            if let urlRequest = router.build() {
                // files라는 parameter 이름으로 이미지 파일들을 올려버림
                AF.upload(multipartFormData: { multipartFormData in
                    dataArray.forEach { data in
                        multipartFormData.append(data.data, withName: "files", fileName: data.dataName, mimeType: "image/png")
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
