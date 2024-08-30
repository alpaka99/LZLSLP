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
    
    func loadImageData(fileURLS: [String]) -> Single<Result<[Data], Error>> {
        return Single.create {[weak self] observer in
            
            guard let repository = self else { return Disposables.create() }
            
            Observable.from(fileURLS)
            .concatMap { fileURL in
                let router = URLRouter.https(.lslp(.image(.image(fileURL))))
                return NetworkManager.shared.requestCall(router: router, interceptor: AuthInterceptor())
            }
            .map { result in
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    return Data()
                }
            }
            .buffer(timeSpan: .milliseconds(500), count: 100, scheduler: MainScheduler.asyncInstance)
            .bind(with: repository) { owner, dataArray in
                if dataArray.count == fileURLS.count {
                    observer(.success(.success(dataArray)))
                }
            }
            .disposed(by: repository.disposeBag)
            
            
            return Disposables.create()
        }
    }
    
}
