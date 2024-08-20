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
    var parameters: [String : String] { get }
}

protocol Pathable {
    var path: String { get }
    var httpMethod: String { get }
    var httpHeaders: [String : String] { get }
    var parameters: [String : String] { get }
}

protocol Endpoitable {
    var endpoint: String { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: [String : String] { get }
    var parameters: [String : String] { get }
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
            
            let components = URLComponents(string: urlString)
            
            if let composedURL = components?.url {
                var urlRequest = URLRequest(url: composedURL)
                // methods
                urlRequest.httpMethod = request.httpMethod
                
                // headers
                for (_, element) in request.httpHeaders.enumerated() {
                    let key = element.key
                    let value = element.value
                    
                    urlRequest.addValue(value, forHTTPHeaderField: key)
                }
                
                
                // parameter as body
                guard let requestBody = try? JSONEncoder().encode(request.parameters) else { return nil }
                urlRequest.httpBody = requestBody
                
                print("url", urlRequest.url?.absoluteString)
                print("Methods", urlRequest.httpMethod)
                print("Headers", urlRequest.allHTTPHeaderFields)
                print("Body", urlRequest.httpBody)
                return urlRequest
            } else {
                print("Cannot create urlRequest")
                return nil
            }
        }
    }
    
    enum HTTPSRequest: Schemable {
        case lslp(LSLPRequest)
        
        var scheme: String {
            return "http://"
        }
        var baseURL: String {
            return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
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
        
        var parameters: [String : String] {
            switch self {
            case .lslp(let request):
                return request.parameters
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
    
    
    var parameters: [String : String] {
        switch self {
        case .auth(let endpoint):
            return endpoint.parameters
        case .like(let endpoint):
            return endpoint.parameters
        case .like2(let endpoint):
            return endpoint.parameters
        case .follow(let endpoint):
            return endpoint.parameters
        case .profile(let endpoint):
            return endpoint.parameters
        case .hashtag(let endpoint):
            return endpoint.parameters
        case .post(let endpoint):
            return endpoint.parameters
        case .comment(let endpoint):
            return endpoint.parameters
        }
    }
    
    
    enum AuthType: Endpoitable {
        case join(SignUpForm)
        case validation(email: String)
        case login(email: String, password: String)
        case accessToken
        case withdraw // 한번 더 로그인 과정을 거치는게 일반적
        
        var httpMethod: HTTPMethod {
            switch self {
            case .join:
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
            default:
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
            }
            
            return headerPayload
        }
        
        var parameters: [String : String] {
            switch self {
            case .join(let registerForm):
                return [
                    "email" : registerForm.email,
                    "password" : registerForm.password,
                    "nick" : registerForm.nick,
                    "phoneNum" : registerForm.phoneNum ?? "",
                    "birthDay" : registerForm.birthDay ?? "",
                ]
            case .validation(email: let email):
                return [
                    "email" : email
                ]
            case .login(email: let email, password: let password):
                return  [
                    "email" : email,
                     "password" : password,
                ]
            case .accessToken:
                return [:]
            case .withdraw:
                return [:]
            }
        }
    }
    
    enum PostType: Endpoitable {
        case postFiles(files: Data)
        case postPost(postForm: PostForm) // 어떤 content를 포스트에 넣을지 생각해보기
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
            switch self {
            default:
                headerPayload[HTTPHeaderKey.contentType.rawValue] = HTTPHeaderKey.contentType.value
                headerPayload[HTTPHeaderKey.sesacKey.rawValue] = HTTPHeaderKey.sesacKey.value
            }
            
            return headerPayload
        }
        
        var parameters: [String : String] {
            switch self {
            case .postFiles(files: let files):
                return [:]
            case .postPost(postForm: let postForm):
                return [
                    "title" : postForm.title,
                    "content" : postForm.content
                ]
            case .getPosts:
                return [:]
            case .getPost:
                return [:]
            case .updatePost:
                return [:]
            case .deletePost:
                return [:]
            case .getUserPost:
                return [:]
            }
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
        
        var parameters: [String : String] {
            return [:]
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
        
        var parameters: [String : String] {
            return [:]
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
        
        var parameters: [String : String] {
            return [:]
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
        
        var parameters: [String : String] {
            return [:]
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
        
        var parameters: [String : String] {
            return [:]
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
        
        var parameters: [String : String] {
            return [:]
        }
    }
}


enum HTTPMethod: String {
    case get = "get"
    case post = "post"
    case put = "put"
    case delete = "delete"
}
   

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
    case sesacKey = "SesacKey"
//    case authorization = "Authorization"
//    case refresh = "Refresh"
    
    var value: String {
        switch self {
        case .contentType:
            return "application/json"
        case .sesacKey:
            return Bundle.main.object(forInfoDictionaryKey: "SeSAC_Key") as? String ?? ""
//        case .authorization:
//            return UserDefaults.standard.load(of: AccessToken.self)?.token ?? ""
//        case .refresh:
//            return UserDefaults.standard.load(of: RefreshToken.self)?.token ?? ""
        }
    }
}


class Temp {
    func temp1() {
        URLRouter.https(.lslp(.auth(.login(email: "alpaka@pakaland.com", password: "1234")))).build()
    }
}

