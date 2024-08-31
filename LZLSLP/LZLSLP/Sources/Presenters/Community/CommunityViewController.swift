//
//  CommunityViewController.swift
//  LZLSLP
//
//  Created by user on 8/25/24.
//

import UIKit

import RxCocoa
import RxSwift

final class CommunityViewController: BaseViewController<CommunityView, CommunityViewModel> {
    
    // MARK: ViewDidLoad로 수정하고 tableView에 refresh 로직 구현
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.store.prefetchTriggered.onNext(())
    }
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.postResponses
            .bind(to: baseView.tableView.rx.items(cellIdentifier: CommunityTableViewCell.identifier, cellType: CommunityTableViewCell.self)) { row, item, cell in
                
                cell.title.text = item.title
                cell.content.text = item.content
                cell.likeNumber.text = String(item.likes.count)
            }
            .disposed(by: disposeBag)
        
        baseView.tableView.rx.prefetchRows
            .flatMap { Observable.from(optional: $0) }
            .compactMap({$0.last?.row})
            .bind(with: self) { owner, row in
                if row < 2 {
                    print("Triggerd: \(row)")
                    owner.viewModel.store.prefetchTriggered.onNext(())
                }
            }
            .disposed(by: disposeBag)
            
        
        baseView.tableView.rx.modelSelected(PostResponse.self)
            .bind(with: self) { owner, postResponse in
                
                let detailPostViewModel = DetailPostViewModel()
                detailPostViewModel.store.postId.accept(postResponse.postId)
                
                let detailPostViewController = DetailPostViewController(
                    baseView: DetailPostView(),
                    viewModel: detailPostViewModel
                )
                
                owner.navigationController?.pushViewController(detailPostViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.store.isRefreshing
            .bind(to: baseView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        baseView.refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.store.refreshTriggered)
            .disposed(by: disposeBag)
        
        baseView.floatingButton.rx.tap
            .bind(with: self) { owner, _ in
                let postViewController = PostViewController(
                    baseView: PostView(),
                    viewModel: PostViewModel()
                )
                
                owner.navigationController?.pushViewController(postViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.titleView = LogoView(fontSize: 16, weight: .semibold, logoColor: .black)
    }
}
