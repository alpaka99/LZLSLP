//
//  PostViewModel.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit

final class PostViewModel: RxViewModel {
    struct Input: Inputable {
        
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
}
