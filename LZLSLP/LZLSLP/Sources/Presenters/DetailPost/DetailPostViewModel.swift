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
        

        store.detailPostData
            .flatMap {
                Observable.of($0.files)
            }
            .map {
                let tmep = $0
            }

        
        store.detailPostData
            .flatMap {
                Driver.from($0.files)
            }
            .concatMap { fileURL in
                let router = URLRouter.https(.lslp(.image(.image(fileURL))))
                print("url", router.build()?.url?.absoluteString)
                return self.imageRepository.loadImageData(router: router)
            }
            .map { result in
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print(error)
                    return Data()
                }
            }
            .buffer(timeSpan: .milliseconds(500), count: 100, scheduler: MainScheduler.instance)
            .flatMap {[weak self] value in
                return Observable<[Data]>.create { observer in
                    if let store = self?.store {
                        let fileCount = store.detailPostData.value.files.count
                        if value.count == fileCount {
                            observer.onNext(value)
                        }
                    }
                    
                    return Disposables.create()
                }
            }
//            .toArray() // MARK: 이게 onCompleted되어서 문제 -> Stream을 폐기 -> 그렇다면 drive해주면 되지 않은가? -> Buffer로 해결
            .bind(to: store.loadedImages)
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
