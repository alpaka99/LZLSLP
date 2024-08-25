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
        
        viewModel.store.postResponses
            .bind(to: baseView.tableView.rx.items(cellIdentifier: "UITableViewCell")) { row, item, cell in
                
                cell.textLabel?.text = "\(item.title): \(item.createdAt)"
            }
            .disposed(by: disposeBag)
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Community View"
    }
}
