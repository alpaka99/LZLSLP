//
//  DetailViewModel.swift
//  LZLSLP
//
//  Created by user on 8/27/24.
//

import Foundation

import RxCocoa
import RxSwift

final class DetailPostViewModel: RxViewModel {
    struct Input: Inputable {
        
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
}
