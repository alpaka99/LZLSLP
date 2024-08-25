//
//  CommunityViewController.swift
//  LZLSLP
//
//  Created by user on 8/25/24.
//

import UIKit

final class CommunityViewController: BaseViewController<CommunityView, CommunityViewModel> {
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        viewModel.store.viewIsAppearing.onNext(())
    }
    
    override func configureBind() {
        super.configureBind()
        
        
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Community View"
    }
}
