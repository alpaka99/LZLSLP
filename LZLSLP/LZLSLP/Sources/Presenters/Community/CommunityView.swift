//
//  CommunityView.swift
//  LZLSLP
//
//  Created by user on 8/25/24.
//

import UIKit

import SnapKit

final class CommunityView: BaseView {
    let titleLabel = {
        let label = UILabel()
        label.text = "최신글들을 확인해보세요"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.tableHeaderView = titleLabel
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
        
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        self.addSubview(floatingButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints { label in
            label.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(self.safeAreaLayoutGuide)
            tableView.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        
        floatingButton.snp.makeConstraints { btn in
            btn.size.equalTo(50)
            btn.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(20)
        }
    }
}
