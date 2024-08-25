//
//  CommunityView.swift
//  LZLSLP
//
//  Created by user on 8/25/24.
//

import UIKit

import SnapKit

final class CommunityView: BaseView {
    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        return tableView
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
