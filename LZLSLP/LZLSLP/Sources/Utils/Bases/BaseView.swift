//
//  BaseView.swift
//  LZLSLP
//
//  Created by user on 8/15/24.
//

import UIKit

class BaseView: UIView {
    private(set) var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureUI() { self.backgroundColor = .white }
    func configureTapGestureRecognizer() {
        self.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
    }
}

