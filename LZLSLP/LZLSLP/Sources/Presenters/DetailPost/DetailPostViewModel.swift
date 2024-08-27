//
//  DetailViewModel.swift
//  LZLSLP
//
//  Created by user on 8/27/24.
//

import Foundation

import RxCocoa
import RxSwift

final class DetailPostViewModel: RxViewModel {
    struct Input: Inputable {
        var detailPostData = PublishRelay<PostResponse>()
        var fireButtonTapped = PublishSubject<Void>()
        var comment = PublishSubject<String>()
    }
    
    struct Output: Outputable {
        var likedStatus = BehaviorRelay(value: false)
    }
    var store = ViewStore(input: Input(), output: Output())
    
    let postRepository = PostRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.detailPostData
            .bind(with: self) { owner, postData in
                guard let userId = UserDefaults.standard.load(of: UserInfo.self)?.userId else { return }
                
                owner.store.likedStatus.accept(postData.likes.contains(userId))
            }
            .disposed(by: disposeBag)
        
        
        store.fireButtonTapped
            .withLatestFrom(Observable.combineLatest(store.detailPostData, store.likedStatus))
            .flatMap { value in
                let postData = value.0
                let toggledLikedStatus = !value.1
                
                let router = URLRouter.https(.lslp(.like(.likePost(postData.postId, toggledLikedStatus))))
                
                return self.postRepository.requestPostAPI(of: LikeStatus.self, router: router)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.store.likedStatus.accept(response.likeStatus)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        Observable
            .zip(store.detailPostData, store.comment)
            .flatMap { value in
                let postData = value.0
                let comment = value.1
                
                let router = URLRouter.https(.lslp(.comment(.postComment(id: postData.postId, comment: comment))))
                return self.postRepository.requestPostAPI(of: CommentResponse.self, router: router)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("Comment response: \(response)")
                case .failure(let error):
                    print("Comment error: \(error)")
                }
            }
            .disposed(by: disposeBag)
//            .flatMap {
//                let comment = $0
//                let router = URLRouter.https(.lslp(.comment(.postComment(id: <#T##String#>, comment: <#T##String#>))))
//                
//            }
    }
}

struct LikeStatus: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

struct CommentResponse: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}
