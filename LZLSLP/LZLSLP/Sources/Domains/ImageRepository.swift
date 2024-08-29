//
//  ImageRepository.swift
//  LZLSLP
//
//  Created by user on 8/29/24.
//

import Foundation

import RxCocoa
import RxSwift

final class ImageRepository {
    let disposeBag = DisposeBag()
    func loadImageData(router: Router) -> Single<Result<Data, Error>> {
        return Single.create { observer in
            
            NetworkManager.shared.requestCall(router: router, interceptor: AuthInterceptor())
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let data):
                        observer(.success(.success(data)))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func loadThumbnailImageData(_ images: [String]) -> Data {
        if let thumbnailURL = images.first {
            let router = URLRouter.https(.lslp(.image(.image(thumbnailURL))))
            
            return Data()
        } else {
            return Data()
        }
    }
}
