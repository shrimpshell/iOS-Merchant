//
//  Instant.swift
//  iOS-Merchant
//
//  Created by Josh Hsieh on 2018/11/21.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

struct Instant:Codable {
    var idInstantDetail: Int
    var idInstantService: Int
    var status: Int
    var quantity: Int
    var idInstantType: Int
    var idRoomStatus: Int
    var roomNumber: String

    enum CodingKeys: String, CodingKey {
        case idInstantDetail = "IdInstantDetail"
        case idInstantService = "IdInstantService"
        case status = "Status"
        case quantity = "Quantity"
        case idInstantType = "IdInstantType"
        case idRoomStatus = "IdRoomStatus"
        case roomNumber = "RoomNumber"
        
    }
    
}
