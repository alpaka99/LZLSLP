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
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(tableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        tableView.snp.makeConstraints { tableView in
            tableView.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
