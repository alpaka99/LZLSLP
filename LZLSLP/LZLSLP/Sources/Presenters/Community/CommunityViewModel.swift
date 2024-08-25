//
//  CommunityViewModel.swift
//  LZLSLP
//
//  Created by user on 8/25/24.
//

import Foundation

import RxCocoa
import RxSwift

final class CommunityViewModel: RxViewModel {
    struct Input: Inputable {
        var viewIsAppearing = PublishSubject<Void>()
        var currentPage = BehaviorRelay(value: 0)
        var postResponses = BehaviorRelay(value: [PostResponse]())
        var nextCursor: String = ""
        var prefetchTriggered = PublishSubject<Void>()
    }
    
    struct Output: Outputable {
        
    }
    
    let repository = PostRepository()
    
    var store = ViewStore(input: Input(), output: Output())
    
    override func configureBind() {
        super.configureBind()
        
        store.viewIsAppearing
            .flatMap { _ in
                let nextCursor: String = self.store.nextCursor
                
                let router = URLRouter.https(.lslp(.post(.getPosts(nextCursor: nextCursor, limit: 8, productId: "gasoline_post"))))
                
                return self.repository.requestPostAPI(of: GetPostResponse.self, router: router)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.store.reduce(owner.store.nextCursor, into: response.nextCursor)
                    owner.store.postResponses.accept(response.data)
                case .failure(let error):
                    break
                }
            }
            .disposed(by: disposeBag)
        
        store.prefetchTriggered
            .filter {
                let nextCursor: String = self.store.nextCursor
                return nextCursor != "0"
            }
            .flatMap { _ in
                let nextCursor: String = self.store.nextCursor
                
                let router = URLRouter.https(.lslp(.post(.getPosts(nextCursor: nextCursor, limit: 8, productId: "gasoline_post"))))
                
                return self.repository.requestPostAPI(of: GetPostResponse.self, router: router)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.store.reduce(owner.store.nextCursor, into: response.nextCursor)
                    
                    var data = owner.store.postResponses.value
                    data.append(contentsOf: response.data)
                    owner.store.postResponses.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}

struct GetPostResponse: Decodable {
    let data: [PostResponse]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}
