//
//  DetailViewController.swift
//  LZLSLP
//
//  Created by user on 8/27/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DetailPostViewController: BaseViewController<DetailPostView, DetailPostViewModel> {
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.commentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.detailPostData
            .map {
                $0.title
            }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.store.detailPostData
            .map {
                print($0.comments)
                return $0.comments
            }
            .bind(to: baseView.commentTableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { row, item ,cell in
                
                print("Cell row: \(row)")
                print("Comment: \(item.content)")
                cell.textLabel?.text = item.content
            }
            .disposed(by: disposeBag)
        
        
        
        baseView.fireButton.rx.tap
            .bind(to: viewModel.store.fireButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.store.likedStatus
            .bind(with: self) { owner, value in
                
                owner.baseView.fireButton.updateImage(value ? "flame.fill" : "flame")
            }
            .disposed(by: disposeBag)
        
        baseView.commentTextField.rx.controlEvent([.editingDidEndOnExit])
            .withLatestFrom(baseView.commentTextField.rx.text.orEmpty)
            .bind(to: viewModel.store.comment)
            .disposed(by: disposeBag)
    }
}
