//
//  DonationViewModel.swift
//  LZLSLP
//
//  Created by user on 9/2/24.
//

import Foundation

import RxCocoa
import RxSwift

final class DonationViewModel: RxViewModel {
    struct Input: Inputable {
        let donationButtonTapped = PublishSubject<Void>()
        let paymentValidationResponse = PublishSubject<PaymentValidationResponse>()
    }
    
    struct Output: Outputable {
        let paymentResponse = PublishSubject<PaymentResponse>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    let paymentRepository = PaymentRepository()
    
    override func configureBind() {
        super.configureBind()
        
        store.paymentResponse
            .flatMap { paymetResponse in
                let router = URLRouter.https(.lslp(.payment(.validation(paymetResponse.impUID))))
                return self.paymentRepository.requestPaymentValidation(of: PaymentValidationResponse.self, router: router)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let paymentValidationResponse):
                    owner.store.paymentValidationResponse.onNext(paymentValidationResponse)
                case .failure(let error):
                    print("DonationViewModel error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
}

struct PaymentValidationResponse: Decodable {
    let buyerID: String
    let postID: String
    let merchantUID: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case buyerID = "buyer_id"
        case postID = "post_id"
        case merchantUID = "merchant_uid"
        case productName
        case price
        case paidAt
    }
}
