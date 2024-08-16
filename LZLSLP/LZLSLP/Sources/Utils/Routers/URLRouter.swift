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
}

protocol Pathable {
    var path: String { get }
}

protocol Endpoitable {
    var endpoint: String { get }
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
                print(url.absoluteString)
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
    
    
    enum AuthType: Endpoitable {
        case join(RegisterForm)
        case validation
        case login
        case accessToken
        case withdraw
        
        struct RegisterForm {
            let email: String
            let password: String
            let nick: String
            let phoneNum: String?
            let birthDay: String?
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
    }
    
    enum PostType: Endpoitable {
        case postFiles
        case postPost
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
    }
    
    enum HashtagType: Endpoitable {
        case searchHashTag
        
        var endpoint: String {
            switch self {
            case .searchHashTag:
                return "/posts/hashtags"
            }
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

   



class Temp {
    func temp1() {
        URLRouter.https(.lslp(.auth(.accessToken))).build()
        
    }
}
