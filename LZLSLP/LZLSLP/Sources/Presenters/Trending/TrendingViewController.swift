//
//  TrendingViewController.swift
//  LZLSLP
//
//  Created by user on 8/19/24.
//

import UIKit

final class TrendingViewController: BaseViewController<TrendingView, TrendingViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Trending View"
    }
}
