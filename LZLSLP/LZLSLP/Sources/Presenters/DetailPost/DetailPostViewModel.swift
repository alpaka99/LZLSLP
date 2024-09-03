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
        var postId = PublishRelay<String>()
        var fireButtonTapped = PublishSubject<Void>()
        var comment = PublishSubject<String>()
        var loadDetailPostData = PublishSubject<Void>()
    }
    
    struct Output: Outputable {
        var likedStatus = BehaviorRelay(value: false)
        var detailPostData = BehaviorRelay<PostResponse>(value: PostResponse.dummyData)
        var loadedImages = BehaviorSubject<[Data]>(value: [])
    }
    var store = ViewStore(input: Input(), output: Output())
    
    let postRepository = PostRepository()
    let imageRepository = ImageRepository()
    
    override func configureBind() {
        super.configureBind()
        
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
            .combineLatest(store.postId, store.comment)
            .flatMap { value in
                let postId = value.0
                let comment = value.1
                let router = URLRouter.https(.lslp(.comment(.postComment(id: postId, comment: comment))))
                return self.postRepository.requestPostAPI(of: CommentResponse.self, router: router)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.store.loadDetailPostData.onNext(())
                case .failure(let error):
                    print("Comment error: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        // initial load DetailPost Data
        store.postId
            .flatMap { id in
                let router = URLRouter.https(.lslp(.post(.getPost(id: id))))
                return self.postRepository.requestPostAPI(of: PostResponse.self, router: router)
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    owner.store.detailPostData.accept(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        // load post when need
        store.loadDetailPostData
            .withLatestFrom(store.postId)
            .flatMap { id in
                let router = URLRouter.https(.lslp(.post(.getPost(id: id))))
                return self.postRepository.requestPostAPI(of: PostResponse.self, router: router)
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    owner.store.detailPostData.accept(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        store.detailPostData
            .share()
            .bind(with: self) { owner, postData in
                guard let userId = UserDefaults.standard.load(of: UserInfo.self)?.userId else { return }
                owner.store.likedStatus.accept(postData.likes.contains(userId))
            }
            .disposed(by: disposeBag)
        

        
        // image loading sequence
        store.detailPostData
            .flatMap {
                return self.imageRepository.loadImageData(fileURLS: $0.files)
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let imageArray):
                    owner.store.loadedImages.onNext(imageArray)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
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
