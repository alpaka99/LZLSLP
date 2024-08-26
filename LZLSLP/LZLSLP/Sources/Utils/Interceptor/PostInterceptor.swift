//
//  MultipartInterceptor.swift
//  LZLSLP
//
//  Created by user on 8/22/24.
//

import Foundation

import Alamofire

final class PostInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        print(#function, String(describing: self))
        guard let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token
        else {
            completion(.failure(InterceptorError.tokenURLBuildError))
            return
        }
        print("\(String(describing: self)) loaded AccessToken")
        var urlRequest = urlRequest
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    
    // 만약 access token 문제라면 retry
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print(#function, String(describing: self))
        // invalidAccessToken 에러가 아니라면 retry하지 않고 통과시킴
        guard let response = request.response, response.statusCode == 419 else {
            print(#function, String(describing: self), "Not 419 error")
            completion(.doNotRetry)
            return
        }
        print(String(describing: self), response.statusCode)
        guard let urlRequest = URLRouter.https(.lslp(.auth(.accessToken))).build() else { return }
        
        AF.request(urlRequest, interceptor: AuthInterceptor())
            .responseDecodable(of: RefreshTokenResponse.self) { result in
                switch result.result {
                case .success(let data):
                    let accessToken = AccessToken(token: data.accessToken)
                    UserDefaults.standard.save(accessToken)
                    completion(.retry)
                case .failure(let error):
                    print("PostInterceptor Error: \(error)")
                    completion(.doNotRetryWithError(InterceptorError.accessTokenResponseFailureError))
                }
            }
    }
}


