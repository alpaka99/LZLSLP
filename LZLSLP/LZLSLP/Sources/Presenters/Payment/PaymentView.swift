//
//  PaymentView.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import UIKit
import WebKit

import SnapKit

final class PaymentView: BaseView {
    lazy var wkWebView = {
        var view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(wkWebView)
        
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        wkWebView.snp.makeConstraints { webView in
            webView.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
