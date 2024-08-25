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
    }
    
    struct Output: Outputable {
        
    }
    
    let repository = PostRepository()
    
    var store = ViewStore(input: Input(), output: Output())
    
    override func configureBind() {
        super.configureBind()
        
        store.viewIsAppearing
            .flatMap { _ in
                let router = URLRouter.https(.lslp(.post(.getPosts)))
                
                return self.repository.requestPostAPI(of: GetPostResponse.self, router: router)
            }
            .bind(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
        
    }
    
    
}

struct GetPostResponse: Decodable {
    let data: [PostResponse]
    let nextCursor: String
}
