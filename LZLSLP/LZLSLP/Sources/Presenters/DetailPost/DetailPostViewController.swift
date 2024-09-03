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
        
        baseView.commentTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        baseView.imageCollectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
    }
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.detailPostData
            .share()
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
                let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: IndexPath(row: row, section: 0))
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
        
        
        // MARK: 만약 loadedImage 가 없으면 collectionView의 크기를 줄여버리기
        viewModel.store.loadedImages
            .bind(to: baseView.imageCollectionView.rx.items(cellIdentifier: DetailImageCell.identifier, cellType: DetailImageCell.self)) { row, data, cell in
                let image = UIImage(data: data)
                
                cell.imageView.image = image
            }
            .disposed(by: disposeBag)
        
        
        // MARK: image가 없다면 collectionView의 높이 줄여버리기
            
    }
}
