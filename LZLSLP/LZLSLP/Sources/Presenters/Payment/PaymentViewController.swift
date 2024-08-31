//
//  PaymentViewController.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import UIKit
import WebKit

import iamport_ios
import SnapKit
import RxCocoa
import RxSwift


final class PaymentViewController: BaseViewController<PaymentView, PaymentViewModel> {
    
    let payment = {
        let sesacKey = Bundle.main.object(forInfoDictionaryKey: "SeSAC_Key") as? String ?? ""
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(sesacKey)_\(Int(Date().timeIntervalSince1970))",
            amount: "1200"
        ).then { payment in
            payment.pay_method = PayMethod.card.rawValue
            payment.name = "LZLSLP Test"
            payment.buyer_name = "Alpaka99"
            payment.app_scheme = "LZLSLP"
        }
        
        return payment
    }()
    
    
    let userCode = "imp57573124"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Donation View"
        
       
        
    }
    
    override func configureBind() {
        super.configureBind()
        
        Iamport.shared.paymentWebView(webViewMode: baseView.wkWebView, userCode: userCode, payment: payment) { iamportResponse in
            print(String(describing: iamportResponse))
        }
    }
}
