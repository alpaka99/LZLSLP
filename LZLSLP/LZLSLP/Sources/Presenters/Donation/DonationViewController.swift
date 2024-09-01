//
//  DonationViewController.swift
//  LZLSLP
//
//  Created by user on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DonationViewController: BaseViewController<DonationView, DonationViewModel> {
    
    override func configureBind() {
        super.configureBind()
        
        baseView.coffeeTapRecognizer.rx.event
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                let paymentViewController = PaymentViewController(
                    baseView: PaymentView(),
                    viewModel: PaymentViewModel()
                )
                let paymentNavigationController = UINavigationController(rootViewController: paymentViewController)
                
                paymentNavigationController.modalPresentationStyle = .formSheet
                
                owner.present(paymentNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
