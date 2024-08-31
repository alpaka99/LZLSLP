//
//  DonationViewController.swift
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


final class DonationViewController: UIViewController {
    
    let payment = {
        let sesacKey = Bundle.main.object(forInfoDictionaryKey: "SeSAC_Key") as? String ?? ""
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(sesacKey)_\(Int(Date().timeIntervalSince1970))",
            amount: "1"
        ).then { payment in
            payment.pay_method = PayMethod.card.rawValue
            payment.name = "LZLSLP Test"
            payment.buyer_name = "Alpaka99"
            payment.app_scheme = "LZLSLP"
        }
        
        return payment
    }()
    
    lazy var wkWebView = {
        var view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    let userCode = "imp57573124"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Donation View"
        
//        self.showAlert(title: "결제", message: "테스트") { [weak self] in
//            guard let vc = self else { return }
        view.backgroundColor = .white
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { webView in
            webView.edges.equalTo(view)
        }
            Iamport.shared.paymentWebView(webViewMode: wkWebView, userCode: userCode, payment: payment) { iamportResponse in
                print(String(describing: iamportResponse))
            }
//        }
    }
}
