//
//  SignupViewController.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import UIKit

final class SignupViewController: BaseViewController<SignupView, SignupViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Signup ViewController"
    }
}
