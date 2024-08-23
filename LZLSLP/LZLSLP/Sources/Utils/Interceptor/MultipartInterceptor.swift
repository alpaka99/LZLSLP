//
//  MultipartInterceptor.swift
//  LZLSLP
//
//  Created by user on 8/22/24.
//

import Foundation

import Alamofire

final class MultipartInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.load(of: AccessToken.self)?.token
        else {
            completion(.failure(InterceptorError.tokenURLBuildError))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        completion(.success(urlRequest))
    }
    
    
    // 만약 access token 문제라면 retry
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        // invalidAccessToken 에러가 아니라면 retry하지 않고 통과시킴
        guard let response = request.response, response.statusCode == StatusCode.invalidAccessToken.rawValue else {
            completion(.doNotRetry)
            return
        }
        
        guard let urlRequest = URLRouter.https(.lslp(.auth(.accessToken))).build() else { return }
        
        AF.request(urlRequest, interceptor: AuthInterceptor())
            .responseDecodable(of: RefreshTokenResponse.self) { result in
                switch result.result {
                case .success(let data):
                    let accessToken = AccessToken(token: data.accessToken)
                    UserDefaults.standard.save(accessToken)
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(InterceptorError.accessTokenResponseFailureError))
                }
            }
    }
}


