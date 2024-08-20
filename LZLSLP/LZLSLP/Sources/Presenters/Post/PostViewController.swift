//
//  PostViewController.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit

import RxSwift

final class PostViewController: BaseViewController<PostView, PostViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Post View"
    }
    
    override func configureBind() {
        super.configureBind()
        
        baseView.submitButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    baseView.titleTextField.rx.text.orEmpty,
                    baseView.contentView.rx.text.orEmpty)
            )
            .bind(with: self, onNext: { owner, value in
                let postForm = PostForm(title: value.0, content: value.1)
                owner.viewModel.store.postForm.accept(postForm)
            })
            .disposed(by: disposeBag)
    }
}

struct PostForm {
    let title: String
    let content: String
}
