//
//  ProfileViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/6.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Photos
import PromiseKit
import Starscream
import UserNotifications


class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WebSocketDelegate {

    var department: CDepartment?
    var employee: Employee?
    var rooms = [OrderRoomDetail]()
    var instants = [OrderInstantDetail]()
    var reservation = [Reservation]()
    let download = Common.shared
    var instantStatus = [Instant]()
    var socket: WebSocket!
    var targetImage: UIImagePickerController!

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tagStackView: UIStackView!
    @IBOutlet weak var employeeImageView: UIImageView!
    
    
    // MARL: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // check photo access permission
        checkPermission()
        // image view add action
        targetImage = UIImagePickerController()
        targetImage.delegate = self
        targetImage.allowsEditing = false
        targetImage.sourceType = .photoLibrary
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhotoFromGallery))
        employeeImageView.isUserInteractionEnabled = true
        employeeImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if department != nil {
            department!.showButtons(view: view, stackView: tagStackView, viewController: self)
        }
        if employee != nil {
            self.nameLabel.text = "\(self.employee!.name)"
            self.emailLabel.text = "\(self.employee!.email)"
            self.phoneLabel.text = "\(self.employee!.phone)"
        }
        
        showDepartmentButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let groupId = department?.departmentId.description else {
            return
        }
        socketConnect(userId: (employee?.name)!, groupId: groupId)
        
        switch department?.departmentId {
        case 1:
            getServiceItem(idInstantService: 1)
        case 2:
            getServiceItem(idInstantService: 2)
        case 3:
            getServiceItem(idInstantService: 3)
        default:
            break
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        socketDisConnect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if department?.departmentId == 4 && segue.identifier == "toCheckoutView" {
            let checkoutTableView = segue.destination as? CheckoutTableViewController
            checkoutTableView?.reservation = self.reservation
        }
        guard let departmentId = self.department?.departmentId else{
            return
        }
        if department?.departmentId == 3 && segue.identifier == "toInstantServiceView" {
            let instantServiceVC = segue.destination as? InstantServiceTableViewController
            instantServiceVC?.departmentId = departmentId
            instantServiceVC?.instantStatus = instantStatus
            instantServiceVC?.employee = employee?.name
        } else if department?.departmentId == 2 && segue.identifier == "toInstantServiceView" {
            let instantServiceVC = segue.destination as? InstantServiceTableViewController
            instantServiceVC?.departmentId = departmentId
            instantServiceVC?.instantStatus = instantStatus
            instantServiceVC?.employee = employee?.name
        } else if department?.departmentId == 1 && segue.identifier == "toInstantServiceView" {
            let instantServiceVC = segue.destination as? InstantServiceTableViewController
            instantServiceVC?.departmentId = departmentId
            instantServiceVC?.instantStatus = instantStatus
            instantServiceVC?.employee = employee?.name
        }
    }
    
    // MARK: - custome functions
    private func refactorData() {
        // 重構結構
        for checkout in rooms {
            reservation.append(Reservation(id: checkout.roomGroup, checkout: [], instant: []))
        }
        reservation = reservation.removeDeuplicates()
        for (index, _) in reservation.enumerated() {
            for checkout in rooms {
                if checkout.roomGroup == reservation[index].id {
                    reservation[index].checkout.append(checkout)
                }
            }
            for instant in instants {
                if instant.roomGroup == reservation[index].id {
                    reservation[index].instant.append(instant)
                }
            }
        }
        reservation = reservation.sorted(by: {(first,next) in
            return Int(first.checkout[0].roomReservationStatus)! < Int(next.checkout[0].roomReservationStatus)!
        })
    }
    
    private func showDepartmentButtons() {
        switch department?.departmentId {
        case 5:
            break
        case 4:
            let payment: OrderPaymentDeatil = OrderPaymentDeatil()
            let roomParams: [String: String] = ["action" : "viewRoomPayDetailByEmployee"]
            let instantParams: [String: String] = ["action" : "viewInstantPayDetailByEmployee"]

            payment.viewRoomPayDetailByEmployee(roomParams).then { (ords) -> Promise<[OrderInstantDetail]> in
                self.rooms = ords
                return payment.viewInstantPayDetailByEmployee(instantParams)
            }.then { (oids) -> Promise<Data?> in
                self.instants = oids
                self.refactorData()
                let employeeAuth: EmployeeAuth = EmployeeAuth()
                let imageParams: [String : Any] = ["action":"getImage", "IdEmployee":self.employee!.id]
                return employeeAuth.getEmployeeImage(imageParams)
            }.done { (data) in
                if (data?.count)! > 0 {
                    DispatchQueue.main.async() {
                        self.employeeImageView.image = UIImage(data: data!)
                    }
                }
            }.catch { (error) in
                assertionFailure("CheckoutTableViewController Error: \(error)")
            }
            break
        case 3:
            break
        case 2:
            break
        case 1:
            break
        default:
            print("No department found")
        }
    }
    
    
    // MARL: - @objc page direction
    @objc func gotoCheckoutPage() {
        performSegue(withIdentifier: "toCheckoutView", sender: nil)
    }
    
    @objc func gotoTrafficPage() {
        print("go to traffic page")
        performSegue(withIdentifier: "toInstantServiceView", sender: nil)
    }
    
    @objc func gotoEventPage() {
        print("go to event page")
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EventView"){
            present(controller, animated: true, completion: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func gotoFoodPage() {
        print("go to food page")
        performSegue(withIdentifier: "toInstantServiceView", sender: nil)
    }
    
    @objc func gotoCleanPage() {
        print("go to clean page")
        performSegue(withIdentifier: "toInstantServiceView", sender: nil)
    }
    
    @objc func gotoEditPage() {
        print("go to edit page")
    }
    
    @objc func gotoEmployeePage() {
        print("go to employee page")
    }
    
    @objc func gotoRoomPage() {
        print("go to room page")
        if let controller = storyboard?.instantiateViewController(withIdentifier: "RoomView"){
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc func gotoRoomViewPage() {
        print("go to room view page")
    }
    
    @objc func gotoRatingPage() {
        
    }
    
    @objc func selectPhotoFromGallery() {
        self.present(targetImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { () -> Void in
            guard let employee = self.employee else {
                assertionFailure("employee is nil")
                return
            }
            guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                let imageData = pickedImage.jpegData(compressionQuality: 0.75) else {
                    assertionFailure("image is not ready")
                    return
            }
            
            let imageDataString = imageData.base64EncodedString(options: .lineLength64Characters)
            let employeeAuth = EmployeeAuth()
            let parameters = ["action":"updateImage", "idEmployee":"\(employee.id)", "imageBase64":imageDataString]
            employeeAuth.updateEmployeeImage(parameters as [String : Any]).done { data in
                if data != "0" {
                    self.employeeImageView.image = pickedImage
                }
            }
        }
    }
            
    
    func getServiceItem(idInstantService: Int) {
        download.getEmployeeStatus(idInstantService: idInstantService) { (result, error) in
            if let error = error {
                print("updateUserServiceStatus error: \(error)")
                return
            }
            guard let result = result else {
                print("result is nil.")
                return
            }
            print("updateUserServiceStatus Info is OK.")
            // Decode as [Instant]. 解碼下載下來的 json
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("updateUserServiceStatus Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Instant].self, from: jsonData) else {
                print("updateUserServiceStatus Fail to decode jsonData.")
                return
            }
            print("getEmployeeStatus resultObject: \(resultObject)")
            
            self.instantStatus = resultObject
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            () -> Void in
            print("cancelled")
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    func showLocalNotification(_ message: Socket) {
        getServiceItem(idInstantService: (department?.departmentId)!)
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
}

extension Array where Element: Equatable {
    func removeDeuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}


