//
//  BaseViewController.swift
//  LZLSLP
//
//  Created by user on 8/15/24.
//

import UIKit

import RxSwift

class BaseViewController<V: BaseView, VM: RxViewModel>: UIViewController {
    let baseView: V
    let viewModel: VM
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = baseView
    }
    
    init(baseView: V, viewModel: VM) {
        self.baseView = baseView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureDelegate()
        configureBind()
    }
    
    func configureNavigationItem() { }
    func configureDelegate() { }
    func configureBind() { }
}

