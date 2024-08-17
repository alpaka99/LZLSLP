//
//  SignupViewModel.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

final class SignupViewModel: RxViewModel {
    struct Input: Inputable {
        
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
}
