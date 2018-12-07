//
//  Common.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/26.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import Alamofire

let ACTION = "action"
let ID_CUSTOMER = "IdCustomer"
let CUSTOMER_KEY = "customer"
let RESULT_KEY = "result"
let DATA_KEY = "data"
//Instant_Keys
let ROOMNUMBER_KEY = "roomNumber"
let INSTANT_KEY = "instant"
let IDINSTANTDETAIL_KEY = "idInstantDetail"
let STATUS_KEY = "status"
let ID_INSTANTSERVICE_KEY = "idInstantService"
let ID_CUSTOMER_KEY = "idCustomer"
let RATING_KEY = "rating"
let IDROOMRESERVATION_KEY = "IdRoomReservation"

typealias LDoneHandler = (_ result: Any?, _ error: Error?) -> Void

struct Common {
    
    // Server
    static let SERVER_URL: String = "http://192.168.50.124:8080/ShellService"
    //static let SERVER_URL: String = "http://10.1.1.3:8080/ShellService"
    
    // Websocket
    let SOCKET_URL: String = "ws://192.168.50.124:8080/ShellService/WsServer/"
    //let SOCKET_URL: String = "ws://10.1.1.3:8080/ShellService/WsServer/"

    
    
    let INSTANT_SERVLET = SERVER_URL + "/InstantServlet"
    let PAYDETAIL_SERVLET = SERVER_URL + "/PayDetailServlet"
    let RATING_SERVLET = SERVER_URL + "/RatingServlet"
    
    static let shared = Common()
    
    private init() {
    }
    
    
    // MARK: - InstantService
    func getEmployeeStatus(idInstantService: Int, completion: @escaping LDoneHandler) {
        let parameters: [String : Any] = [ACTION: "getEmployeeStatus", ID_INSTANTSERVICE_KEY: idInstantService]
        
        doPost(urlString: INSTANT_SERVLET, parameters: parameters, completion: completion)
    }
    
    // update InstantServcice Status
    func updateStatus(idInstantDetail: Int, status: Int, completion: @escaping LDoneHandler) {
        let parameters: [String : Any] = [ACTION: "updateStatus", IDINSTANTDETAIL_KEY: idInstantDetail, STATUS_KEY: status]
        
        doPost(urlString: INSTANT_SERVLET, parameters: parameters, completion: completion)
    }
    
    // Ratings
    func getAllCustomerRatings(key: String, completion: @escaping LDoneHandler) {
        let parameters: [String : Any] = [ACTION: key]
        
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
    }
    
    func updateRatingReview(rating: Rating, completion: @escaping LDoneHandler) {
        let parameters: [String : Any] = [ACTION: "updateReview", RATING_KEY: rating]
        
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
    }
    
    func deleteRating(idRoomReservation: Int, completion: @escaping LDoneHandler) {
        let parameters: [String : Any] = [ACTION: "delete", IDROOMRESERVATION_KEY: idRoomReservation]
        
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
    }
    
    
    
    fileprivate func doPost(urlString: String,
                            parameters: [String: Any],
                            completion: @escaping LDoneHandler) {
        
        
        Alamofire.request(urlString, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleJSON(response: response, completion: completion)
        }
    }
    
    private func handleJSON(response: DataResponse<Any>, completion: LDoneHandler) {
        switch response.result {
        case .success(let json):
            print("Get success response: \(json)")
            completion(json, nil)
        case .failure(let error):
            print("Server respond error: \(error)")
            completion(nil, error)
        }
    }
    
    
}


