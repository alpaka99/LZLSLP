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
    }
    
    struct Output: Outputable {
        let paymentResponse = PublishSubject<PaymentResponse>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
}
