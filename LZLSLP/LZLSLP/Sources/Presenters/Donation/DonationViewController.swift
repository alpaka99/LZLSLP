//
//  DonationViewController.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DonationViewController: BaseViewController<DonationView, DonationViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Donation View"
    }
}
