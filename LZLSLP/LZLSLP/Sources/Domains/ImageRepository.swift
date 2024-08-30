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
                case .failure:
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
    
    
    func loadThumbnailImage(fileURLs: [String]) -> Single<Result<Data, Error>> {
        
        return Single.create {[weak self] observer in
            
            guard let repository = self else { return Disposables.create() }
            
            if let thumbnailURL = fileURLs.first {
                repository.loadImageData(fileURLS: [thumbnailURL])
                    .map { result in
                        switch result {
                        case .success(let dataArray):
                            if let thumbnailData = dataArray.first {
                                observer(.success(.success(thumbnailData)))
                            }
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    }
                    .subscribe()
                    .disposed(by: repository.disposeBag)
            } else {
                observer(.success(.success(Data())))
            }
            
            return Disposables.create()
        }
    }
}
