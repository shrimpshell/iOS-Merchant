//
//  Employee.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/24.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

struct Employee: Codable {
    var id: Int, code: String, name: String, password: String, email: String, gender: String, phone: String, address: String, departmentId: Int
}
