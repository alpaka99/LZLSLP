//
//  DonationViewModel.swift
//  LZLSLP
//
//  Created by user on 9/1/24.
//

import Foundation

import RxCocoa
import RxSwift

final class DonationViewModel: RxViewModel {
    struct Input: Inputable {
        
    }
    
    struct Output: Outputable {
        
    }
    
    var store = ViewStore(input: Input(), output: Output())
}
