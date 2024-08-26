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
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        viewModel.store.viewIsAppearing.onNext(())
    }
    
    override func configureBind() {
        super.configureBind()
        
        viewModel.store.postResponses
            .bind(to: baseView.tableView.rx.items(cellIdentifier: "UITableViewCell")) { row, item, cell in
                
//                cell.textLabel?.text = "\(item.title): \(item.createdAt)"
                cell.textLabel?.text = item.createdAt
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
                print(postResponse)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
//        baseView.tableView.prefetchDataSource = self
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Community View"
    }
}
//
//extension CommunityViewController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print(indexPaths)
//    }
//}
