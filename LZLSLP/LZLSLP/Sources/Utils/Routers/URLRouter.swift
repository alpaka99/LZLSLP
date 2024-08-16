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

protocol URLable {
    var baseURL: String { get }
    var port: String { get }
    var path: String { get }
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
            if let url = URL(string: request.scheme) {
                return URLRequest(url: url)
            }
        }
        
        return nil
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



enum LSLPRequest: URLable {
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
        switch self {
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
        case join
        case validation
        case login
        case refreshToken
        case withdraw
        
        var endpoint: String {
            return ""
        }
    }
    
    enum PostType: Endpoitable {
        case postFiles
        case postPost
        case getPosts
        case getPost
        case updatePost
        case getUserPost
        
        var endpoint: String {
            return ""
        }
    }
    
    enum CommentType: Endpoitable {
        case postComment
        case updateComment
        case deleteComment
        
        var endpoint: String {
            return ""
        }
    }
    
    enum LikeType: Endpoitable {
        case likePost
        case getLike
        
        var endpoint: String {
            return ""
        }
    }
    
    enum Like2Type: Endpoitable {
        case likePost
        case getLike
        
        var endpoint: String {
            return ""
        }
    }
    
    enum FollowType: Endpoitable {
        case follow
        case cancelFollow
        
        var endpoint: String {
            return ""
        }
    }
    
    enum ProfileType: Endpoitable {
        case getMyProfile
        case updateMyProfile
        case getOtherProfile
        
        var endpoint: String {
            return ""
        }
    }
    
    enum HashtagType: Endpoitable {
        case searchHashTag
        
        var endpoint: String {
            return ""
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
        
    }
}
