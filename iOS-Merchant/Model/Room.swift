//
//  Room.swift
//  Employee
//
//  Created by Lucy on 2018/11/8.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit


//class Room: Codable {
//    var RoomTypeName = ""
//    var RoomSize = ""
//    var Bed = ""
//    var AdultQuantity = ""
//    var ChildQuantity = ""
//    var RoomQuantity = ""
//    var Price = ""
//    var image = ""
//
//    init(RoomTypeName: String, RoomSize: String, Bed: String, AdultQuantity: String, ChildQuantity: String, RoomQuantity: String, Price: String, image: String) {
//        self.RoomTypeName = RoomTypeName
//        self.RoomSize = RoomSize
//        self.Bed = Bed
//        self.AdultQuantity = AdultQuantity
//        self.ChildQuantity = ChildQuantity
//        self.RoomQuantity = RoomQuantity
//        self.Price = Price
//        self.image = image
//    }
//
//    // plist 存檔路徑
//    private static var fileURL: URL {
//        var documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        documentDir.appendPathComponent("Rooms")
//        documentDir.appendPathExtension("plist")
//        print(documentDir.absoluteString)
//        return documentDir
//    }
//
//    // 存檔
//    static func save(_ rooms:[Room]) {
//        let encoder = PropertyListEncoder()
//
//        if let encodedRooms = try? // try? 發生錯誤就不執行 try! 如果發生例外就直接當機
//            encoder.encode(rooms) {
//            try! encodedRooms.write(to: fileURL, options: .noFileProtection)
//
//        }
//    }
//
//    // 讀檔
//    static func load() -> [Room]? {
//        let decoder = PropertyListDecoder()
//        if let decodeRooms = try? Data(contentsOf: fileURL) {
//            let result = try?
//                decoder.decode(Array<Room>.self , from: decodeRooms)
//            return result
//        }
//        return nil
//    }
//}

struct Room: Codable {//建立struct Room格式化資料使用,須參考JSON結構來定義
    var id: Int
    var name: String
    var roomSize: String
    var bed: String
    var adultQuantity: Int
    var childQuantity: Int
    var roomQuantity: Int
    var price: Int
//    var roomPic: UIImage
    
    
//    enum CodingKeys: String, CodingKey {
//        case idRoomType = "IdRoomType"
//        case roomTypeName = "RoomTypeName"
//        case roomSize = "RoomSize"
//        case bed = "Bed"
//        case adultQuantity = "AdultQuantity"
//        case childQuantity = "ChildQuantity"
//        case roomQuantity = "RoomQuantity"
//        case price = "Price"
//        case roomPic = "RoomPic"
//    }
}

typealias RoomDownloadDoneHandler = ([Room]?, Error?) -> Void//closure取別名

class RoomDownloaderAndUploader {
    
    //取得所有房型資料
    class func downloadRoom(url: URL, doneHandler: @escaping RoomDownloadDoneHandler) {//class method
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Download fail: \(error)")
                return
            }
            
            guard let data = data else {
                assertionFailure("data is nil.")
                return
            }
            //開始解析資料
            guard let items = parseJSON(data: data) else {
                print("Parse nil.")
                DispatchQueue.main.async {
                    doneHandler(nil, error)
                }
                return
            }
            
            print("Parse OK.")
            DispatchQueue.main.async {
                doneHandler(items, nil)
            }
        }
        task.resume()
    }
    
    private class func parseJSON(data: Data) -> [Room]? {
        let decoder = JSONDecoder()
        var results: [Room]? = nil
        
        do {
            results = try decoder.decode([Room].self, from: data)
            print("Parse OK: \(results!)")
        } catch  {
            assertionFailure("Parse Fail: \(error)")
        }
        
        return results
    }
}
