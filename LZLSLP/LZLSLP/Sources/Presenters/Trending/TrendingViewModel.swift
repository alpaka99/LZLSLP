//
//  TrendingViewModel.swift
//  LZLSLP
//
//  Created by user on 8/19/24.
//

import UIKit

final class TrendingViewModel: RxViewModel {
    struct Input: Inputable {
        
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
}
