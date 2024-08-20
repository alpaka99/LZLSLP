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
    
    func requestCall(router: Router, interceptor: Interceptor? = nil) -> Single<Result<Data, Error>> {
        Single.create { observer in
            if let urlRequest = router.build() {
                AF.request(urlRequest, interceptor: interceptor)
                    .validate(statusCode: 200..<300)
                    .responseData { result in
                        switch result.result {
                        case .success(let data):
                            observer(.success(.success(data)))
                        case .failure(let error):
                            switch error {
                            case .createURLRequestFailed:
                                observer(.failure(NetworkError.urlRequestCreateError))
                            case .responseValidationFailed:
                                observer(.failure(NetworkError.responseStatusCodeError))
                            default:
                                observer(.failure(NetworkError.networkError))
                            }
                        }
                    }
            } else {
                observer(.failure(NetworkError.urlRequestCreateError))
            }
            
            return Disposables.create()
        }
    }
    
    func requestCall(router: Router) -> Single<Result<Data, Error>> {
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
                    
                    observer(.success(.success(data)))
                }
                .resume()
            } else {
                observer(.failure(NetworkError.urlRequestCreateError))
            }
            
            return Disposables.create()
        }
    }
}


final class Interceptor: RequestInterceptor {
    // 네트워크 호출 이전에 일어나는 adapt(Access Token을 넣어줌)
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String, 
        let url = urlRequest.url?.absoluteString, url.hasPrefix(baseURL),
        let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token
        else {
            completion(.failure(InterceptorError.tokenURLBuildError))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        // invalidAccessToken 에러가 아니라면 retry하지 않고 통과시킴
        guard let response = request.response, response.statusCode == StatusCode.invalidAccessToken.rawValue else {
            
            completion(.doNotRetryWithError(error))
            return
        }
        
        // invalidAccessToken 에러라면 access token을 refresh하는 retry
        guard var urlRequest = URLRouter.https(.lslp(.auth(.accessToken))).build(),
              let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token,
              let refreshToken = UserDefaults.standard.load(of: RefreshToken.self)?.token
        else {
            completion(.doNotRetryWithError(InterceptorError.tokenURLBuildError))
            return
        }
        
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authrorization")
        urlRequest.addValue(refreshToken, forHTTPHeaderField: "Refresh")
        
        AF.request(urlRequest)
            .responseDecodable(of: RefreshTokenResponse.self) { result in
                switch result.result {
                case .success(let data):
                    let accessToken = AccessToken(token: data.accessToken)
                    UserDefaults.standard.save(accessToken)
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
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
}

// MARK: Status Code enum으로 뺴기
enum StatusCode: Int {
    case success = 200
    case invalidAccessToken = 401
    case forbidden = 403
    case invalidRefreshToken = 418
}
