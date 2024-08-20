//
//  PostViewModel.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit

import RxCocoa
import RxSwift

final class PostViewModel: RxViewModel {
    struct Input: Inputable {
        var postForm = PublishRelay<PostForm>()
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let repository = PostRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.postForm
            .map { postForm in
                let router = URLRouter.https(.lslp(.post(.postPost(postForm: postForm))))
                return router
            }
            .flatMap {
                self.repository.requestAuthAPI(of: PostResponse.self, router: $0)
            }
            .bind(with: self) { ower, result in
                switch result {
                case .success(let postResponse):
                    print(postResponse)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
}

struct PostResponse: Decodable {
    let postId: String
    let productId: String
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case hashTags
        case comments
    }
}

struct Creator: Decodable {
    let userId: String
    let nick: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}
