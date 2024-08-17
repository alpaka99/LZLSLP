//
//  URLRouter.swift
//  LZLSLP
//
//  Created by user on 8/16/24.
//

import Foundation

protocol Router {
    func build() -> URLRequest?
}

protocol Schemable {
    var scheme: String { get }
    var httpMethod: String { get }
    var httpHeaders: [String : String] { get }
}

protocol Pathable {
    var path: String { get }
    var httpMethod: String { get }
    var httpHeaders: [String : String] { get }
}

protocol Endpoitable {
    var endpoint: String { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: [String : String] { get }
}


enum URLRouter: Router {
    case https(HTTPSRequest)
    
    func build() -> URLRequest? {
        switch self {
        case .https(let request):
            
            let scheme = request.scheme
            let baseURL = request.baseURL
            let port = request.port
            let urlString = scheme + baseURL + port + request.path
            
            if let url = URL(string: urlString) {
                var urlRequest = URLRequest(url: url)
                // methods
                urlRequest.httpMethod = request.httpMethod
                
                // headers
                for (_, element) in request.httpHeaders.enumerated() {
                    let key = element.key
                    let value = element.value
                    
                    urlRequest.addValue(key, forHTTPHeaderField: value)
                }
                print(urlRequest.url?.absoluteString)
                print(urlRequest.httpMethod)
                print(urlRequest.allHTTPHeaderFields)
                return URLRequest(url: url)
            } else {
                print("Cannot create urlRequest")
                return nil
            }
        }
    }
    
    enum HTTPSRequest: Schemable {
        case lslp(LSLPRequest)
        
        var scheme: String {
            return "https://"
        }
        var baseURL: String {
            return "naver.com"
        }
        var port: String {
            return "/v1"
        }
        
        var path: String {
            switch self {
            case .lslp(let request):
                return request.path
            }
        }
        
        var httpMethod: String {
            switch self {
            case .lslp(let request):
                return request.httpMethod
            }
        }
        
        var httpHeaders: [String : String] {
            switch self {
            case .lslp(let request):
                return request.httpHeaders
            }
        }
    }
}



enum LSLPRequest: Pathable {
    case auth(AuthType)
    case post(PostType)
    case comment(CommentType)
    case like(LikeType)
    case like2(Like2Type)
    case follow(FollowType)
    case profile(ProfileType)
    case hashtag(HashtagType)
    
    var baseURL: String {
        return "naver.com"
    }
    
    var port: String {
        return "/v1"
    }
    
    var path: String {
        switch self { //MARK: 다 똑같은 코드인데 한줄로 쓰는 방법이 없을까?
        case .auth(let endpoint):
            return endpoint.endpoint
        case .post(let endpoint):
            return endpoint.endpoint
        case .comment(let endpoint):
            return endpoint.endpoint
        case .like(let endpoint):
            return endpoint.endpoint
        case .like2(let endpoint):
            return endpoint.endpoint
        case .follow(let endpoint):
            return endpoint.endpoint
        case .profile(let endpoint):
            return endpoint.endpoint
        case .hashtag(let endpoint):
            return endpoint.endpoint
        }
    }
    
    var httpMethod: String {
        switch self {
        case .auth(let endpoint):
            return endpoint.httpMethod.rawValue
        case .like(let endpoint):
            return endpoint.httpMethod.rawValue
        case .like2(let endpoint):
            return endpoint.httpMethod.rawValue
        case .follow(let endpoint):
            return endpoint.httpMethod.rawValue
        case .profile(let endpoint):
            return endpoint.httpMethod.rawValue
        case .hashtag(let endpoint):
            return endpoint.httpMethod.rawValue
        case .post(let endpoint):
            return endpoint.httpMethod.rawValue
        case .comment(let endpoint):
            return endpoint.httpMethod.rawValue
        }
    }
    
    var httpHeaders: [String : String] {
        switch self {
        case .auth(let endpoint):
            return endpoint.httpHeaders
        case .like(let endpoint):
            return endpoint.httpHeaders
        case .like2(let endpoint):
            return endpoint.httpHeaders
        case .follow(let endpoint):
            return endpoint.httpHeaders
        case .profile(let endpoint):
            return endpoint.httpHeaders
        case .hashtag(let endpoint):
            return endpoint.httpHeaders
        case .post(let endpoint):
            return endpoint.httpHeaders
        case .comment(let endpoint):
            return endpoint.httpHeaders
        }
    }
    
    
    enum AuthType: Endpoitable {
        case join(RegisterForm)
        case validation(email: String)
        case login(email: String, password: String)
        case accessToken
        case withdraw // 한번 더 로그인 과정을 거치는게 일반적
        
        struct RegisterForm {
            let email: String
            let password: String
            let nick: String
            let phoneNum: String?
            let birthDay: String?
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .join(_):
                return .post
            case .validation:
                return .post
            case .login:
                return .post
            case .accessToken:
                return .get
            case .withdraw:
                return .get
            }
        }
        
        var endpoint: String {
            switch self {
            case .join:
                return "/users/join"
            case .validation:
                return "/validation/email"
            case .login:
                return "/users/login"
            case .accessToken:
                return "/auth/refresh"
            case .withdraw:
                return "/users/withdraw"
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            switch self {
            case .join(_):
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
            case .validation(_):
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
            case .login:
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
            case .accessToken:
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
                headerPayload[HTTPHeaderKey.refreshToken.rawValue] = HTTPHeaderKey.refreshToken.value
            case .withdraw:
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
            }
            
            return headerPayload
        }
    }
    
    enum PostType: Endpoitable {
        case postFiles(files: Data)
        case postPost // 어떤 content를 포스트에 넣을지 생각해보기
        case getPosts
        case getPost
        case updatePost
        case deletePost
        case getUserPost
        
        var endpoint: String {
            switch self {
            case .postFiles:
                return "/posts/files"
            case .postPost:
                return "/posts"
            case .getPosts:
                return "/posts"
            case .getPost:
                return "/posts/"
            case .updatePost:
                return "/posts/"
            case .deletePost:
                return "/posts/"
            case .getUserPost:
                return "/posts/users/"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .postFiles:
                return .post
            case .postPost:
                return .post
            case .getPosts:
                return .get
            case .getPost:
                return .get
            case .updatePost:
                return .put
            case .deletePost:
                return .delete
            case .getUserPost:
                return .get
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
    enum CommentType: Endpoitable {
        case postComment
        case updateComment
        case deleteComment
        
        var endpoint: String {
            switch self {
            case .postComment:
                return "/posts/:id/comments"
            case .updateComment:
                return "/posts/:id/comments/:commentID"
            case .deleteComment:
                return "/posts/:id/comments/:commentID"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .postComment:
                return .post
            case .updateComment:
                return .put
            case .deleteComment:
                return .delete
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
    enum LikeType: Endpoitable {
        case likePost
        case getLike
        
        var endpoint: String {
            switch self {
            case .likePost:
                return "/posts/:id/like"
            case .getLike:
                return "/posts/likes/me"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .getLike:
                return .get
            case .likePost:
                return .post
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
    enum Like2Type: Endpoitable {
        case likePost
        case getLike
        
        var endpoint: String {
            switch self {
            case .likePost:
                return "/posts/:id/like-2"
            case .getLike:
                return "/posts/likes-2/me"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .likePost:
                return .post
            case .getLike:
                return .get
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
    enum FollowType: Endpoitable {
        case follow
        case cancelFollow
        
        var endpoint: String {
            switch self {
            case .follow:
                return "/follow/:id"
            case .cancelFollow:
                return "/follow/:id"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .follow:
                return .post
            case .cancelFollow:
                return .post
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
    enum ProfileType: Endpoitable {
        case getMyProfile
        case updateMyProfile
        case getOtherProfile
        
        var endpoint: String {
            switch self {
            case .getMyProfile:
                return "/users/me/profile"
            case .updateMyProfile:
                return "/users/me/profile"
            case .getOtherProfile:
                return "/users/:id/profile"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .getMyProfile:
                return .get
            case .updateMyProfile:
                return .put
            case .getOtherProfile:
                return .get
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
    enum HashtagType: Endpoitable {
        case searchHashTag
        
        var endpoint: String {
            switch self {
            case .searchHashTag:
                return "/posts/hashtags"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .searchHashTag:
                return .get
            }
        }
        
        var httpHeaders: [String : String] {
            var headerPayload: [String : String] = [:]
            return headerPayload
        }
    }
    
}



//enum Path: Pathable {
//    var path: String {
//        switch self {
//        case .auth(let temp), .post(let temp):
//            return temp.endPoint
//        default:
//            return ""
//        }
//    }
//    
//    case auth(Endpointable)
//    case post(Endpointable)
//    case comment
//    case like
//    case like2
//    case follow
//    case profile
//    case hashtag
//    
//    
//    enum AuthType: Endpointable {
//        var endPoint: String {
//            return ""
//        }
//    }
//    
//    enum PostType: Endpointable {
//        var endPoint: String {
//            return ""
//        }
//    }
//}

//enum HTTPRequestType {
//    case auth(AuthType)
//    case post(PostType)
//    case comment(CommentType)
//    case like(LikeType)
//    case like2(Like2Type)
//    case follow(FollowType)
//    case profile(ProfileType)
//    case hashtag(HashTagType)
//    
//    
//    enum AuthType {
//        case join
//        case validation
//        case login
//        case refresh
//        case withdraw
//        
//        
//    }
//    
//    enum PostType {
//        case files
//        case postPost
//        case getPosts
//        case getPost
//        case deletePost
//        case getUserPost
//    }
//    
//    enum CommentType {
//        case postComment
//        case updateComment
//        case deleteComment
//    }
//    
//    enum LikeType {
//        case like
//        case cancelLike
//    }
//    
//    enum Like2Type {
//        case like
//        case cancelLike
//    }
//    
//    enum FollowType {
//        case follow
//        case cancelFollow
//    }
//    
//    enum ProfileType {
//        case getProfile
//        case updateProfile
//        case getOthersProfile(String)
//    }
//    
//    enum HashTagType {
//        case search
//    }
//}

enum HTTPMethod: String {
    case get = "get"
    case post = "post"
    case put = "put"
    case delete = "delete"
}
   

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
    case sesacKey = "SesacKey"
    case refreshToken = "Refresh"
    
    var value: String {
        switch self {
        case .contentType:
            return "application/json"
        case .sesacKey:
            return "SesacKeyValue"
        case .refreshToken:
            return "RefreshTokenValue"
        }
    }
}


class Temp {
    func temp1() {
        URLRouter.https(.lslp(.auth(.accessToken))).build()
        
    }
}

