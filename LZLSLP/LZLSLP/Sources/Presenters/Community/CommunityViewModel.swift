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
        var postResponses = PublishSubject<[PostResponse]>()
        var thumbnailImages = PublishSubject<[Data]>()
        var nextCursor: String = ""
        var prefetchTriggered = PublishSubject<Void>()
        var refreshTriggered = PublishSubject<Void>()
    }
    
    struct Output: Outputable {
        var isRefreshing = BehaviorSubject(value: false)
        var combinedData = BehaviorRelay<[CombinedData]>(value: [])
    }
    
    let postRepository = PostRepository()
    let imageRepository = ImageRepository()
    
    var store = ViewStore(input: Input(), output: Output())
    
    override func configureBind() {
        super.configureBind()
        
        store.prefetchTriggered
            .filter {
                let nextCursor: String = self.store.nextCursor
                return nextCursor != "0"
            }
            .flatMap { _ in
                let nextCursor: String = self.store.nextCursor
                
                let router = URLRouter.https(.lslp(.post(.getPosts(nextCursor: nextCursor, limit: 8, productId: "gasoline_post"))))
                
                return self.postRepository.requestPostAPI(of: GetPostResponse.self, router: router)
            }            
            .bind(with: self) { owner, result in
                switch result { // MARK: 만약 cursor의 마지막 데이터의 날짜가 오늘 날짜가 아니라면 nextCursor를 "0"으로 바꿈, REfresh시ㅣ cursor를 ""으로 바꿈
                case .success(let response):
                    owner.store.reduce(owner.store.nextCursor, into: response.nextCursor)
                    
                    let filteredData = response.data.filter {
                        let formatter = ConstDateFormatter.formatter
                        formatter.dateFormat = ConstDateFormatter.iso8601format
                        if let date = formatter.date(from: $0.createdAt) {
//                            print("\(date) is in sameMonth in today: \(Calendar.current.isDate(date, inSameDayAs: Date.now))")
//                            return Calendar.current.isDate(date, inSameDayAs: Date.now)
                            return true
                        } else {
                            print("Date Error")
                            return false
                        }
                    }
                    owner.store.postResponses.onNext(filteredData)
                    owner.store.isRefreshing.onNext(false)
                case .failure(let error):
                    print("Load Post Response error: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        store.refreshTriggered
            .bind(with: self) { owner, _ in
                owner.store.reduce(owner.store.nextCursor, into: "")
//                owner.store.postResponses.onNext([])
//                owner.store.thumbnailImages.onNext([])
                owner.store.combinedData.accept([])
                owner.store.prefetchTriggered.onNext(())
            }
            .disposed(by: disposeBag)
        
        store.postResponses
            .flatMap {
                let responseArray = $0
                
                var thumbnailArray = [String]()
                for response in responseArray {
                    if let thumbnailImage = response.files.first {
                        thumbnailArray.append(thumbnailImage)
                    } else {
                        thumbnailArray.append("") // ImageRepository에서 에러가 발생해도 Data()를 반환해서 괜찮을듯?
                    }
                }
                
                return Observable.just(thumbnailArray)
            }
            .flatMap {
                return self.imageRepository.loadImageData(fileURLS: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let dataArray):
                    owner.store.thumbnailImages.onNext(dataArray)
                case .failure(let error):
                    print("ThumbnailImage Error: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(store.postResponses, store.thumbnailImages)
            .map { (postResponse, thumbnailImages) in
               let zippedArray = zip(postResponse, thumbnailImages)
                
                var combinedDataArray = [CombinedData]()
                for (postResponse, thumbnailImage) in zippedArray {
                    let combinedData = CombinedData(cellImage: thumbnailImage, cellData: postResponse)
                    combinedDataArray.append(combinedData)
                }
                
                return combinedDataArray
            }
            .bind(with: self) { owner, value in
                let cellData = owner.store.combinedData.value
                let newData = cellData + value
                owner.store.combinedData.accept(newData)
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

struct CombinedData {
    let cellImage: Data?
    let cellData: PostResponse
}
