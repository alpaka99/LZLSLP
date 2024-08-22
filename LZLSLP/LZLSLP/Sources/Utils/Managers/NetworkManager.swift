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
    
    func requestCall(router: Router, interceptor: AuthInterceptor? = nil) -> Single<Result<Data, Error>> {
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
}

struct RefreshTokenResponse: Decodable {
    let accessToken: String
}

//final class Interceptor {
//    /*
//     MARK: Interceptor Logic 만들기
//     
//     Interceptor:
//     */
//    func intercept(completionHandler: @escaping (Result<Data, Error>)->Void) {
//        if let urlRequest = URLRouter.https(.lslp(.auth(.accessToken))).build() {
//            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//                guard error == nil else {
//                    completionHandler(.failure(InterceptorError.tokenFetchError))
//                    return
//                }
//                
//                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
//                    completionHandler(.failure(InterceptorError.tokenResponseStatusError))
//                    return
//                }
//                
//                guard let data = data else {
//                    completionHandler(.failure(InterceptorError.nilTokenError))
//                    return
//                }
//                
//                
//                completionHandler(.success(data))
//                return
//            }
//            .resume()
//        } else {
//            completionHandler(.failure(InterceptorError.tokenURLBuildError))
//        }
//    }
//}

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
    case invalidAccessToken = 401
    case forbidden = 403
    case invalidRefreshToken = 418
}
