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
    lazy var payment = {
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(viewModel.store.sesacKey)_\(Int(Date().timeIntervalSince1970))",
            amount: "1200"
        ).then { payment in
            payment.pay_method = PayMethod.card.rawValue
            payment.name = "LZLSLP Test"
            payment.buyer_name = "Alpaka99"
            payment.app_scheme = "LZLSLP"
        }
        
        return payment
    }()
    
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)

    
    override func configureBind() {
        super.configureBind()
        
        Iamport.shared.paymentWebView(webViewMode: baseView.wkWebView, userCode: viewModel.store.userCode, payment: payment) {[weak self] iamportResponse in
            guard let response = iamportResponse else { return }
            
            guard let success = response.success, let impUID = response.imp_uid, let merchantUID = response.merchant_uid else  { return }
            
            let paymentResonse = PaymentResponse(merchantUID: merchantUID, success: success, impUID: impUID)
            
            self?.viewModel.store.paymentResponse.onNext(paymentResonse)
        }
        
        leftBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.store.paymentResponse
            .share()
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}
