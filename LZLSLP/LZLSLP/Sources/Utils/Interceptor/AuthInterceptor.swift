//
//  AuthInterceptor.swift
//  LZLSLP
//
//  Created by user on 8/22/24.
//

import Foundation

import Alamofire

final class AuthInterceptor: RequestInterceptor {
    // 네트워크 호출 이전에 일어나는 adapt(Access Token을 넣어줌)
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token
        else {
            completion(.failure(InterceptorError.tokenURLBuildError))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        print(urlRequest.headers)
        completion(.success(urlRequest))
    }
    
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        // invalidAccessToken 에러가 아니라면 retry하지 않고 통과시킴
        guard let response = request.response, response.statusCode == StatusCode.invalidAccessToken.rawValue else {
            print("Access Token is correct, so pass")
            completion(.doNotRetry)
            return
        }
        
        print("Retry Sequnce Start")
        // invalidAccessToken 에러라면 access token을 refresh하는 retry
        let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token
        let refreshToken = UserDefaults.standard.load(of: RefreshToken.self)?.token
        
        guard var urlRequest = URLRouter.https(.lslp(.auth(.accessToken))).build(),
              let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token,
              let refreshToken = UserDefaults.standard.load(of: RefreshToken.self)?.token
        else {
            completion(.doNotRetryWithError(InterceptorError.tokenURLBuildError))
            return
        }
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.addValue(refreshToken, forHTTPHeaderField: "Refresh")
        
//        print("URLREquestHEader: \(urlRequest.headers)")
        
        AF.request(urlRequest)
//            .validate(statusCode: 200..<300)
//            .responseString { result in
//                print(result)
//            }
            .responseDecodable(of: RefreshTokenResponse.self) { result in
                print(result.response?.statusCode)
                switch result.result {
                case .success(let data):
                    let accessToken = AccessToken(token: data.accessToken)
                    UserDefaults.standard.save(accessToken)
                    completion(.retry)
                case .failure(let error):
                    print("AccessToken Refresh Failure")
                    completion(.doNotRetryWithError(InterceptorError.accessTokenResponseFailureError))
                }
            }
    }
}
