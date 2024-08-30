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
        var postResponses = BehaviorRelay(value: [PostResponse]())
        var nextCursor: String = ""
        var prefetchTriggered = PublishSubject<Void>()
        var refreshTriggered = PublishSubject<Void>()
    }
    
    struct Output: Outputable {
        var isRefreshing = BehaviorSubject(value: false)
    }
    
    let repository = PostRepository()
    
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
                
                return self.repository.requestPostAPI(of: GetPostResponse.self, router: router)
            }            
            .bind(with: self) { owner, result in
                switch result { // MARK: 만약 cursor의 마지막 데이터의 날짜가 오늘 날짜가 아니라면 nextCursor를 "0"으로 바꿈, REfresh시ㅣ cursor를 ""으로 바꿈
                case .success(let response):
                    owner.store.reduce(owner.store.nextCursor, into: response.nextCursor)
                    var data = owner.store.postResponses.value
                    let newData = response.data.filter {
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
                    data.append(contentsOf: newData)
                    owner.store.postResponses.accept(data)
                    owner.store.isRefreshing.onNext(false)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        store.refreshTriggered
            .bind(with: self) { owner, _ in
                owner.store.reduce(owner.store.nextCursor, into: "")
                owner.store.postResponses.accept([])
                owner.store.prefetchTriggered.onNext(())
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
