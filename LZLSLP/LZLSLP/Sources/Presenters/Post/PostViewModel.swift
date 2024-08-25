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
        var postForm = BehaviorRelay<PostForm>(value: PostForm(title: "", content: "", files: []))
        var selectedImageData = PublishRelay<ImageForm>()
        var submitButtonTapped = PublishSubject<Void>()
        var toastMessage = PublishSubject<String>()
    }
    
    struct Output: Outputable {
        var imageArray = BehaviorRelay<[ImageForm]>(value: [])
        var uploadedImageArray = PublishRelay<[String]>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let repository = PostRepository()
    
    override func configureBind() {
        super.configureBind()
        
        
        // 1. 우선은 이미지를 서버에 보냄
        store.submitButtonTapped
            .flatMap { _ in // 1. image 요청
                let imageArray = self.store.imageArray.value
                
                // send image array with MultiPartFormData
                let router = URLRouter.https(.lslp(.post(.postFiles)))
                return self.repository.requestPostDataAPI(of: ImageUploadResponse.self, router: router, imageArray: imageArray)
            }
            .flatMap { result in
                var postForm = self.store.postForm.value
                
                switch result {
                case .success(let imageResponse):
                    postForm.files = imageResponse.files
                    print(postForm)
                    let router = URLRouter.https(.lslp(.post(.postPost(postForm: postForm))))
                    return self.repository.requestPostAPI(of: PostResponse.self, router: router)
                case .failure(let error):
                    return Single.just(.failure(error))
                }
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    owner.store.toastMessage.onNext("토스트 바삭바삭") // 토스트 메세지 넣어주기
//                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 2. 이미지가 서버에 업로드가 제대로 처리 됐다면, postForm을 올림
        store.uploadedImageArray
            .map { value in
                var postForm = self.store.postForm.value
                postForm.files = value
                return postForm
            }
            .flatMap { postForm in
                let router = URLRouter.https(.lslp(.post(.postPost(postForm: postForm))))
                return NetworkManager.shared.requestCall(router: router, interceptor: AuthInterceptor())
            }
            .bind(with: self, onNext: { owner, result in
                // post result work
            })
            .disposed(by: disposeBag)
        
        
        store.selectedImageData
            .bind(with: self) { owner, data in
                var dataArray = owner.store.imageArray.value
                dataArray.append(data)
                owner.store.imageArray.accept(dataArray)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func transform() {
        
        store.submitButtonTapped
            .flatMap { _ in // 1. image 요청
                let imageArray = self.store.imageArray.value
                
                // send image array with MultiPartFormData
                let router = URLRouter.https(.lslp(.post(.postFiles)))
                return self.repository.requestPostDataAPI(of: ImageUploadResponse.self, router: router, imageArray: imageArray)
            }
            .flatMap { result in
                var postForm = self.store.postForm.value
                
                switch result {
                case .success(let imageResponse):
                    postForm.files = imageResponse.files
                    print(postForm)
                    let router = URLRouter.https(.lslp(.post(.postPost(postForm: postForm))))
                    return self.repository.requestPostAPI(of: PostResponse.self, router: router)
                case .failure(let error):
                    return Single.just(.failure(error))
                }
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
//                    owner.store.toastMessage.onNext("토스트 바삭바삭") // 토스트 메세지 넣어주기
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

struct PostResponse: Decodable {
    let postId: String
    let productId: String?
    let title: String
    let content: String
//    let content1: String
//    let content2: String
//    let content3: String
//    let content4: String
//    let content5: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let buyers: [String]
    let hashTags: [String]
    let comments: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
//        case content1
//        case content2
//        case content3
//        case content4
//        case content5
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case buyers
        case hashTags
        case comments
    }
}

struct Creator: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct ImageUploadResponse: Decodable {
    let files: [String]
}
