//
//  RoomDetailTableViewController.swift
//  iOS-Merchant
//
//  Created by Nick Wen on 2018/12/2.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class RoomDetailTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    let TAG = "RoomDetailTableViewController"
    var id: Int = 0
    let communicator = Communicator.shared
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roomSizeTextField: UITextField!
    @IBOutlet weak var bedTextField: UITextField!
    @IBOutlet weak var adultQuantityTextField: UITextField!
    @IBOutlet weak var childQuantityTextField: UITextField!
    @IBOutlet weak var roomQuantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var savaBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var roomImageView: UIImageView!
    var room: Room!
    var name_temp_value = ""
    var roomSize_temp_value = ""
    var bed_temp_value = ""
    var adultQuantity_temp_value = ""
    var childQuantity_temp_value = ""
    var roomQuantity_temp_value = ""
    var price_temp_value = ""
    
//    var roomEdit: Room?
//    var room_temp: Room?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomImageView.image = UIImage(named: "picture")
        
        id = room.id
        //        LogHelper.println(tag: TAG, line: #line, "id: \(id)")
        
        nameTextField.text = room.name
        roomSizeTextField.text = room.roomSize
        bedTextField.text = room.bed
        adultQuantityTextField.text = String(room.adultQuantity)
        childQuantityTextField.text = String(room.childQuantity)
        roomQuantityTextField.text = String(room.roomQuantity)
        priceTextField.text = String(room.price)
        
        name_temp_value = room.name
        roomSize_temp_value = room.roomSize
        bed_temp_value = room.bed
        adultQuantity_temp_value = String(room.adultQuantity)
        childQuantity_temp_value = String(room.childQuantity)
        roomQuantity_temp_value = String(room.roomQuantity)
        price_temp_value = String(room.price)
       
        
        let imageUrl = Common.SERVER_URL + "/RoomTypeServlet?action=getImage&imageId=\(room.id)"
            
            let url = URL(string: imageUrl)
            
            let data = try? Data(contentsOf: url!)
        
            roomImageView.image = UIImage(data: data!)

        savaBarButtonItem.isEnabled = false
      
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        roomImageView.image = nil
    }
    
    
    @IBAction func editingChangedBarButtonItemEnabled(_ sender: Any) {
        campareEditingValue()
        
    }
    
    @IBAction func saveBarBtnPressed(_ sender: UIBarButtonItem) {
        
        guard let roomImageView = roomImageView.image else {
            assertionFailure("roomImageView not found!")
            return
        }
        
        let imageBase64 =  convertImageToBase64(image: roomImageView)
        
        let name = nameTextField.text!
        let roomSize = roomSizeTextField.text!
        let bed = bedTextField.text!
        let adultQuantity = adultQuantityTextField.text!
        let childQuantity = childQuantityTextField.text!
        let roomQuantity = roomQuantityTextField.text!
        let price = priceTextField.text!
        
        
        guard name.count != 0 &&
              roomSize.count != 0 &&
              bed.count != 0 &&
              adultQuantity.count != 0 &&
              childQuantity.count != 0 &&
              roomQuantity.count != 0 &&
              price.count != 0 &&
              imageBase64.count != 0 else {
              let alertController = UIAlertController(title: "房間資料不齊全", message:
                    "請確認輸入資料是否完整", preferredStyle: UIAlertController.Style.alert)
              alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                
              self.present(alertController, animated: true, completion: nil)
              return
        }
        
        guard let adultQuantityDB = Int(adultQuantity),
              let childQuantityDB = Int(adultQuantity),
              let roomQuantityDB = Int(roomQuantity),
              let priceDB = Int(price) else {
              assertionFailure("adultQuantity or adultQuantity or roomQuantity or roomQuantity or price Cast to Int Fail")
                return
        }
        
        let room = Room(
            id: id,
            name: name,
            roomSize: roomSize,
            bed: bed,
            adultQuantity: adultQuantityDB,
            childQuantity: childQuantityDB,
            roomQuantity: roomQuantityDB,
            price: priceDB
            )
        
//        room_temp = room
        
        //轉JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let roomData = try? encoder.encode(room) else {
            assertionFailure("Cast news to json is Fail.")
            return
        }
        
        print(String(data: roomData, encoding: .utf8)!)
        
        guard let roomString = String(data: roomData, encoding: .utf8) else {
            assertionFailure("Cast newsData to String is Fail.")
            return
        }
        
        //寫入資料庫
        communicator.roomUpdate(room: roomString, photo: imageBase64) { (result, error) in
            if let error = error {
                print("Insert room fail: \(error)")
                return
            }
            
            guard let updateStatus = result as? Int else {
                assertionFailure("modify fail.")
                return
            }
            
            if updateStatus == 1 {
                //跳出成功視窗
                let alertController = UIAlertController(title: "完成", message:
                    "儲存成功！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: false, completion: nil)
                
//                 self.dismiss(animated: true)
                
            } else {
                let alertController = UIAlertController(title: "失敗", message:
                    "儲存失敗，請確認輸入資料否正確！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        //儲存按鈕消失
        self.savaBarButtonItem.isEnabled = false
    }
    

    //檢查是否欄位值有更改才能儲存
    func campareEditingValue() {
        
        if  nameTextField.text != name_temp_value ||
            roomSizeTextField.text != roomSize_temp_value ||
            bedTextField.text != bed_temp_value ||
            adultQuantityTextField.text != adultQuantity_temp_value ||
            childQuantityTextField.text != childQuantity_temp_value ||
            roomQuantityTextField.text != roomQuantity_temp_value ||
            priceTextField.text != price_temp_value
        {
            savaBarButtonItem.isEnabled = true
        } else {
            savaBarButtonItem.isEnabled = false
        }
    }
    
    @IBAction func imageViewPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        savaBarButtonItem.isEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            roomImageView.image = selectedImage
            roomImageView.contentMode = .scaleAspectFill
            roomImageView.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //將UIImage轉成Base64編碼格式
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }

    
//    // MARK: - Navigation 準備讓上一頁取值
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "save" else {
//            return
//        }
//        roomEdit = room_temp//等等要讓上一頁來取
//
//    }
    
}
