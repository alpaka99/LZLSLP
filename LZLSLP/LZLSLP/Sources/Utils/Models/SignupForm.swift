//
//  SignupForm.swift
//  LZLSLP
//
//  Created by user on 8/17/24.
//

import Foundation

struct SignUpForm: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}
