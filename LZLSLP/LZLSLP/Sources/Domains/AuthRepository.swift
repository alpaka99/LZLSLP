//
//  AuthRepository.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

import RxSwift

final class AuthRepository {
    let disposeBag = DisposeBag()
    
    var router = PublishSubject<Router>()
    var data = PublishSubject<Data>()
    
    init() {
        configureBind()
    }
    
    func configureBind() {
        router
            .bind(with: self) { owner, router in
                let result = NetworkManager.shared.requestCall(router: router)
                    .catch { error in
                        Single.just(Data())
                    }
                
                
            }
            .disposed(by: disposeBag)
    }
}
