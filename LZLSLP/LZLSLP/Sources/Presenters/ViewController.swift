//
//  ViewController.swift
//  LZLSLP
//
//  Created by user on 8/15/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBlue
        navigationItem.title = "LSLP :D"
        
        let temp = Temp()
        temp.temp1()
    }
}

