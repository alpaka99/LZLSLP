//
//  PaymentViewModel.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import Foundation

import RxCocoa
import RxSwift

final class PaymentViewModel: RxViewModel {
    struct Input: Inputable {
        let sesacKey = Bundle.main.object(forInfoDictionaryKey: "SeSAC_Key") as? String ?? ""
        let userCode = "imp57573124"
        
        
    }
    
    struct Output: Outputable {
        let paymentResponse = PublishSubject<PaymentResponse>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
}

struct PaymentResponse {
    let merchantUID: String
    let success: Bool
    let impUID: String   
}
