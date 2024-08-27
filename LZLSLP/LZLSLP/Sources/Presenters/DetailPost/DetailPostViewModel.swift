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
        
        
//            .flatMap {
//                let likedStatus = self.store.likedStatus.value
//                let router = URLRouter.https(.lslp(.like(.likePost(<#T##String#>, <#T##Bool#>))))
//            }
        
//        store.postId
//            .flatMap {
//                let router = URLRouter.https(.lslp(.post(.getPost(id: $0))))
//                return self.postRepository.requestPostAPI(of: PostResponse.self, router: router)
//            }
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let response):
//                    owner.store.detailPostData.onNext(response)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .disposed(by: disposeBag)
            
    }
}

struct LikeStatus: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
