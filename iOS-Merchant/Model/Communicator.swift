//
//  Communicator.swift
//  iOS-Merchant
//
//  Created by Nick Wen on 2018/11/7.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation
import Alamofire


//共用參數
let ACTION_KEY = "action"
let IMAGEID_KEY = "imageId"
let IMAGESIZE_KEY = "imageSize"
let IMAGEBASE64 = "imageBase64"
let ROOM_KEY = "room"
let EVENT_KEY = "event"

//result:[String:Any] is dictionary declaration.
typealias DoneHandler = (_ result: Any?, _ error:Error?) -> Void
typealias DownloadDoneHandler = (_ result:Data?, _ error:Error?) -> Void


class Communicator {  //Singleton instance 單一實例模式
    
    // SERVER_URL 常數
    
    static let BASEURL = Common.SERVER_URL
    let ROOMTYPESERVLET_URL = BASEURL + "/RoomTypeServlet"
    let EventServlet_URL = BASEURL + "/EventServlet"
    
    static let shared = Communicator()
    private init() {
        
    }
    
    
    
    //MARK: - Common methods.
    // 發Request到Server(圖片)
    private func doPostForPhoto(urlString:String, parameters:[String: Any], completion: @escaping DownloadDoneHandler) {
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            self.handlePhoto(response: response, completion: completion)
            
        }
    }
    
    // 處理Server回傳的圖片
    private func handlePhoto(response: DataResponse<Data>, completion: DownloadDoneHandler) {
        guard let data = response.data else {
            print("data is nil")
            let error = NSError(domain: "Invalid Image object.", code: -1, userInfo: nil)
            completion(nil, error)
            return
        }
        completion(data, nil)
    }
    
    
    
    // 發Request到Server(文字)
    func doPost(urlString:String, parameters:[String: Any], completion: @escaping DoneHandler) {
        
        Alamofire.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            self.handleJSON(response: response, completion: completion)
        }
        
    }
    
    
    // 處理Server回傳的JSON
    private func handleJSON(response: DataResponse<Any>, completion: DoneHandler) {
        switch response.result {
        case .success(let json):
            print("Get success response: \(json)")
            completion(json, nil)
        case .failure(let error):
            print("Server respond error: \(error)")
            completion(nil, error)
            
        }
        
    }
/***房間預覽***/
    //新增
    func roomInsert(room: String, photo: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "roomInsert", ROOM_KEY: room, IMAGEBASE64: photo]
        doPost(urlString: ROOMTYPESERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //修改
    func roomUpdate(room: String, photo: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "roomUpdate", ROOM_KEY: room, IMAGEBASE64: photo]
        doPost(urlString: ROOMTYPESERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //刪除
    func roomRemove(room: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "roomRemove", ROOM_KEY: room]
        doPost(urlString:ROOMTYPESERVLET_URL, parameters:parameters, completion:completion)
    }
    
    //取照片
    func getPhotoById(id: Int, completion: @escaping DownloadDoneHandler) {
        let parameters:[String : Any] = [ACTION_KEY: "getImage", IMAGEID_KEY: id]
        return doPostForPhoto(urlString: ROOMTYPESERVLET_URL, parameters: parameters, completion: completion)
    }
    
/***活動訊息***/
    //取活動訊息，文字部分
    func getAllEvents(completion: @escaping DoneHandler) {
        let parameters:[String : Any]  = [ACTION_KEY: "getAll" ]
        return doPost(urlString: EventServlet_URL, parameters: parameters, completion: completion)
    }
    
    //取活動照片
    func getPhotoById(photoURL: String, id: Int, completion: @escaping DownloadDoneHandler) {
        let parameters:[String : Any] = [ACTION_KEY: "getImage", IMAGEID_KEY: id]
        return doPostForPhoto(urlString: photoURL, parameters: parameters, completion: completion)
    }
    
    //新增
    func eventInsert(event: String, photo: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "eventInsert", EVENT_KEY: event, IMAGEBASE64: photo]
        doPost(urlString: EventServlet_URL, parameters: parameters, completion:completion)
    }
    
    //修改
    func eventUpdate(event: String, photo: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "eventUpdate", EVENT_KEY: event, IMAGEBASE64: photo]
        doPost(urlString: EventServlet_URL, parameters: parameters, completion: completion)
    }
    
    //刪除
    func eventRemove(event: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "eventRemove", EVENT_KEY: event]
        doPost(urlString: EventServlet_URL, parameters: parameters, completion: completion)
    }
}








