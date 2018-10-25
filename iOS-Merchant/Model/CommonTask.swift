//
//  CommonTask.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/20.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import PromiseKit

struct CommonTask {
//    let SERVER_URI: String = "ws://192.168.50.46:8080/ShellService/WsServer/"
//    let SERVER_URL: String = "http://172.20.10.3:8080/ShellService" //手機
    let SERVER_URL: String = "http://192.168.50.46:8080/ShellService"
    var servlet: String
    
    init(servlet: String) {
        self.servlet = servlet
    }
    
    func isValidUser(_ params: [String: String]) -> Promise<String> {
        let completeURL = SERVER_URL + servlet
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        var isValidAccount = "false"
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }
                
                let validResult = String(data: data, encoding: .utf8)
                isValidAccount = String(describing: validResult!)
                return result.resolve(isValidAccount, nil)
            }.resume()
        }
    }
    
    func isCorrectUser(_ params: [String: String]) -> Promise<String> {
        let completeURL = SERVER_URL + servlet
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        var idEmployee = "0"
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }
                
                let id = String(data: data, encoding: .utf8)
                idEmployee = String(describing: id!)
                return result.resolve(idEmployee, nil)
            }.resume()
        }
    }
    
    func getEmployeeInfo(_ params: [String: String]) -> Promise<Employee?> {
        let completeURL = SERVER_URL + servlet
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        var receivedInfo: Employee? = nil
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }
                
                let decoder = JSONDecoder()
                receivedInfo = try? decoder.decode(Employee.self, from: data)
                return result.resolve(receivedInfo, nil)
            }.resume()
        }
    }
}
