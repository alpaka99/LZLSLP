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
        var postId = PublishSubject<String>()
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let postRepository = PostRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.postId
            .flatMap {
                let router = URLRouter.https(.lslp(.post(.getPost(id: $0))))
                return self.postRepository.requestPostAPI(of: PostResponse.self, router: router)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
    }
}
