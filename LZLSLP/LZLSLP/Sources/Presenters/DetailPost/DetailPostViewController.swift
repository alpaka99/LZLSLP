//
//  DetailViewController.swift
//  LZLSLP
//
//  Created by user on 8/27/24.
//

import UIKit

final class DetailPostViewController: BaseViewController<DetailPostView, DetailPostViewModel> {
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.detailPostData
            .map {
                $0.title
            }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        
        baseView.fireButton.rx.tap
            .bind(to: viewModel.store.fireButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.store.likedStatus
            .bind(with: self) { owner, value in
                
                owner.baseView.fireButton.updateImage(value ? "flame.fill" : "flame")
            }
            .disposed(by: disposeBag)
    }
}
