//
//  Room.swift
//  Employee
//
//  Created by Lucy on 2018/11/8.
//  Copyright © 2018 Lucy. All rights reserved.
//

import Foundation

class Room: Codable {
    var RoomTypeName = ""
    var RoomSize = ""
    var Bed = ""
    var AdultQuantity = ""
    var ChildQuantity = ""
    var RoomQuantity = ""
    var Price = ""
    var image = ""
    
    init(RoomTypeName: String, RoomSize: String, Bed: String, AdultQuantity: String, ChildQuantity: String, RoomQuantity: String, Price: String, image: String) {
        self.RoomTypeName = RoomTypeName
        self.RoomSize = RoomSize
        self.Bed = Bed
        self.AdultQuantity = AdultQuantity
        self.ChildQuantity = ChildQuantity
        self.RoomQuantity = RoomQuantity
        self.Price = Price
        self.image = image
    }
    
    // plist 存檔路徑
    private static var fileURL: URL {
        var documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentDir.appendPathComponent("Rooms")
        documentDir.appendPathExtension("plist")
        print(documentDir.absoluteString)
        return documentDir
    }
    
    // 存檔
    static func save(_ rooms:[Room]) {
        let encoder = PropertyListEncoder()
        
        if let encodedRooms = try? // try? 發生錯誤就不執行 try! 如果發生例外就直接當機
            encoder.encode(rooms) {
            try! encodedRooms.write(to: fileURL, options: .noFileProtection)
            
        }
    }
    
    // 讀檔
    static func load() -> [Room]? {
        let decoder = PropertyListDecoder()
        if let decodeRooms = try? Data(contentsOf: fileURL) {
            let result = try?
                decoder.decode(Array<Room>.self , from: decodeRooms)
            return result
        }
        return nil
    }
}
