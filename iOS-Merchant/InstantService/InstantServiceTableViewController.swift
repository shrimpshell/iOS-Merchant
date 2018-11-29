//
//  InstantServiceTableViewController.swift
//  iOS-Merchant
//
//  Created by Josh Hsieh on 2018/11/20.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Starscream
import UserNotifications



class InstantServiceTableViewController: UITableViewController, WebSocketDelegate {

    var departmentId: Int?
    let download = Common.shared
    var socket: WebSocket!
    var employee: String?
    var count = 0
    
    var arrayInstantStatusForImage: [String] = []
    var arrayInstantStatusForInfo: [String] = []
    var arrayInstantRoomNumber: [String?] = []
    var arrayInstantType:[String] = []
    var arrayInstantQuantity:[String] = []
    var arrayInstantIdInstantDetail:[String] = []
    var instantStatus = [Instant]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let groupId = departmentId?.description else {
            return
        }
       socketConnect(userId: employee!, groupId: groupId)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        socketDisConnect()
    }
    
    
    func setCell() {
       
        arrayInstantType.removeAll()
        arrayInstantQuantity.removeAll()
        arrayInstantRoomNumber.removeAll()
        arrayInstantStatusForInfo.removeAll()
        arrayInstantStatusForImage.removeAll()
        arrayInstantIdInstantDetail.removeAll()
        
        for status in instantStatus {
            switch status.status {
            case 1:
                self.arrayInstantStatusForImage.append("icon_unfinish")
                self.arrayInstantStatusForInfo.append("1")
            case 2:
                self.arrayInstantStatusForImage.append("icon_playing")
                self.arrayInstantStatusForInfo.append("2")
            case 3:
                self.arrayInstantStatusForImage.append("icon_finish")
                self.arrayInstantStatusForInfo.append("3")
            default:
                break
            }
        }
        
        for type in instantStatus {
            switch type.idInstantType {
            case 1:
                self.arrayInstantType.append("A餐")
            case 2:
                self.arrayInstantType.append("B餐")
            case 3:
                self.arrayInstantType.append("C餐")
            case 4:
                self.arrayInstantType.append("機場接送")
            case 5:
                self.arrayInstantType.append("車站接送")
            case 6:
                self.arrayInstantType.append("高鐵接送")
            case 7:
                self.arrayInstantType.append("清潔服務")
            case 8:
                self.arrayInstantType.append("洗衣服務")
            case 9:
                self.arrayInstantType.append("枕頭備品")
            case 10:
                self.arrayInstantType.append("盥洗用具")
            default:
                break
            }
        }
        
        for quantity in instantStatus {
            self.arrayInstantQuantity.append(String(quantity.quantity))
        }
        
        for roomnumber in instantStatus {
            self.arrayInstantRoomNumber.append(roomnumber.roomNumber)
        }
        
        for idInstantDetail in instantStatus {
            self.arrayInstantIdInstantDetail.append(String(idInstantDetail.idInstantDetail))
        }
        
        print("Debug >>> setCell")
        
        tableView.reloadData()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return instantStatus.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceDetailTableViewCell

        // Configure the cell...
        
        cell.statusImage.image = UIImage(named: arrayInstantStatusForImage[indexPath.row])
        cell.statusLabelForRoomNumber.text = arrayInstantRoomNumber[indexPath.row]
        cell.statusLabelForServiceType.text = arrayInstantType[indexPath.row]
        cell.statusLabelForCount.text = arrayInstantQuantity[indexPath.row]
       

        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceDetailTableViewCell
        
        guard let idInstantDetail = Int(arrayInstantIdInstantDetail[indexPath.row].description) else {
            return
        }
        
        guard let status = Int(arrayInstantStatusForInfo[indexPath.row].description) else {
            return
        }
        
        guard let roomNumber = arrayInstantRoomNumber[indexPath.row] else {
            return
        }
        
        let socketMessage = Socket(senderId: employee!, receiverId: roomNumber , senderGroupId: (departmentId?.description)!, receiverGroupId: "0", serviceId: departmentId!, instantNumber: idInstantDetail)
        let socketData = try! JSONEncoder().encode(socketMessage)
        let socketString = String(data: socketData, encoding: .utf8)!
        
        
        switch status {
        case 1:
            download.updateStatus(idInstantDetail: idInstantDetail, status: 2) { (result, error) in
                if let error = error {
                    print("UpdateStatus text error: \(error)")
                    return
                }
                self.getServiceItem(idInstantService: self.departmentId!)
                print("UpdateStatus case 1 to 2 text OK: \(result!)")
            }
            
            socketSendMessage(socketMessage: socketString)
            
        case 2:
            download.updateStatus(idInstantDetail: idInstantDetail, status: 3) { (result, error) in
                if let error = error {
                    print("UpdateStatus text error: \(error)")
                    return
                }
                self.getServiceItem(idInstantService: self.departmentId!)
                print("UpdateStatus case 2 to 3 OK: \(result!)")
            }
            
            socketSendMessage(socketMessage: socketString)
            
        default:
            break
        }
        
    }
    

    
    func getServiceItem(idInstantService: Int) {
        download.getEmployeeStatus(idInstantService: idInstantService) { (result, error) in
            if let error = error {
                print("getEmployeeStatus 2 error: \(error)")
                return
            }
            guard let result = result else {
                print("result is nil.")
                return
            }
            print("getEmployeeStatus 2 Info is OK.")
            // Decode as [Instant]. 解碼下載下來的 json
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("getEmployeeStatus 2 Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Instant].self, from: jsonData) else {
                print("getEmployeeStatus 2 Fail to decode jsonData.")
                return
            }
            print("getEmployeeStatus 2 resultObject: \(resultObject)")
            
            self.instantStatus = resultObject
            self.setCell()
        }
    }
    
    func showLocalNotification(_ message: Socket) {
        getServiceItem(idInstantService: departmentId!)
        print("Debug >>> showLocalNotification")
        
    }
    
    
    func socketConnect(userId: String, groupId: String) {
        socket = WebSocket(url: URL(string: download.SOCKET_URL + userId + "/" + groupId)!)
        socket.delegate = self
        socket.connect()
    }
    
    func socketDisConnect() {
        socket.disconnect()
    }
    
    func socketSendMessage(socketMessage: String) {
        socket.write(string: socketMessage)
        
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
        let decoder = JSONDecoder()
        let jsonData = text.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        let message = try! decoder.decode(Socket.self, from: jsonData)
        
        showLocalNotification(message)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}

