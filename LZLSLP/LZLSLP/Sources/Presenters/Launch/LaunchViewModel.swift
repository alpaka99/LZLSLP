//
//  LaunchViewModel.swift
//  LZLSLP
//
//  Created by user on 8/30/24.
//

import Foundation

import RxCocoa
import RxSwift

final class LaunchViewModel: RxViewModel {
    struct Input: Inputable {
        var viewDidLoad = PublishSubject<Void>()
        var triggerAnimation = PublishSubject<Void>()
    }
    
    struct Output: Outputable {
        var screenType = PublishSubject<ScreenType>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let authRepository = AuthRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.viewDidLoad
            .share()
            .flatMap {
                let router = URLRouter.https(.lslp(.auth(.accessToken)))
                
                return self.authRepository.requestAuthAPI(of: RefreshTokenResponse.self, router: router, interceptor: AuthInterceptor())
            }
            .delay(.milliseconds(2500), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    print("Success")
                    owner.store.screenType.onNext(.community)
                case .failure:
                    print("Error")
                    owner.store.screenType.onNext(.login)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}

enum ScreenType {
    case community
    case login
}
