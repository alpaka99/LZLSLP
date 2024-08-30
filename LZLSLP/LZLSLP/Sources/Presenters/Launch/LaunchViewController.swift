//
//  LaunchViewController.swift
//  LZLSLP
//
//  Created by user on 8/30/24.
//

import UIKit

final class LaunchViewController: BaseViewController<LaunchView, LaunchViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.store.viewDidLoad.onNext(())
    }
    
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.screenType
            .withUnretained(self)
            .bind { owner, screenType in
                switch screenType {
                case .community:
                    let communityViewController = CommunityViewController(baseView: CommunityView(), viewModel: CommunityViewModel())
                    owner.setNewViewController(nextViewController: communityViewController, isNavigation: true)
                case .login:
                    let loginViewController = LoginViewController(baseView: LoginView(), viewModel: LoginViewModel())
                    owner.setNewViewController(nextViewController: loginViewController, isNavigation: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "LaunchScreen"
    }
}
