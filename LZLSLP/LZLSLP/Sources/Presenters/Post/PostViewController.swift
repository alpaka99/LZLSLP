//
//  PostViewController.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit

final class PostViewController: BaseViewController<PostView, PostViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Post View"
    }
}
