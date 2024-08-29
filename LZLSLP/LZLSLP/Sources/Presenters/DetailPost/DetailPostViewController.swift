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
        baseView.imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
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
                return $0.comments
            }
            .asDriver(onErrorJustReturn: [CommentResponse]())
            .drive(baseView.commentTableView.rx.items) { tableView, row ,data in
                let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = data.content
                return cell
                }
            .disposed(by: disposeBag)
        
        viewModel.store.detailPostData
            .bind(with: self) { owner, postData in
                owner.navigationItem.rx.title.onNext(postData.title)
                owner.baseView.contentLabel.rx.text.onNext(postData.content)
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
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.store.comment)
            .disposed(by: disposeBag)
        
        
        viewModel.store.loadedImages
            .debug("DetailViewController")
            .bind(to: baseView.imageCollectionView.rx.items(cellIdentifier: "UICollectionViewCell", cellType: UICollectionViewCell.self)) { row, item, cell in
                
                print("\(row)번째 Cell")
                cell.largeContentImage = UIImage(data: item)
            }
            .disposed(by: disposeBag)
    }
}
