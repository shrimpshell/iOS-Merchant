//
//  Reservation.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/11.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

struct Reservation: Equatable {
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var checkout: [Checkout]
}
