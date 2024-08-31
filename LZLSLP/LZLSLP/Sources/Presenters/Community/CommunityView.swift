//
//  CommunityView.swift
//  LZLSLP
//
//  Created by user on 8/25/24.
//

import UIKit

import SnapKit

final class CommunityView: BaseView {
    lazy var tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    let refreshControl = {
        let control = UIRefreshControl()
        control.endRefreshing()
        return control
    }()
    
    let floatingButton = {
        let button = UIButton.Configuration.plain()
            .image(systemName: "plus")
            .backgroundColor(.systemRed.withAlphaComponent(0.75))
            .foregroundColor(.white)
            .cornerStyle(.capsule)
            .build()
        
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(tableView)
        self.addSubview(floatingButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        tableView.snp.makeConstraints { tableView in
            tableView.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints { btn in
            btn.size.equalTo(50)
            btn.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(20)
        }
    }
}
