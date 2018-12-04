//
//  AddRoomTableViewController.swift
//  Employee
//
//  Created by Lucy on 2018/11/10.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class AddRoomTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    let TAG = "AddRoomTableViewController"
    
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
    
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savaBarButtonItem.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                photoImageView.image = selectedImage
                photoImageView.contentMode = .scaleAspectFill
                photoImageView.clipsToBounds = true
            }
            dismiss(animated: true, completion: nil)
        }
    
    //檢查是否欄位值有更改才能儲存
    func campareEditingValue() {
            savaBarButtonItem.isEnabled = true
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
        communicator.roomInsert(room: roomString, photo: imageBase64) { (result, error) in
            if let error = error {
                print("Insert room fail: \(error)")
                return
            }
            
            guard let updateStatus = result as? Int else {
                assertionFailure("modify fail.")
                return
            }
            
            if updateStatus == 1 {
//                //跳出成功視窗
//                let alertController = UIAlertController(title: "完成", message:
//                    "儲存成功", preferredStyle: .alert)
//                self.present(alertController, animated: true)
//                //儲存按鈕消失
//                self.savaBarButtonItem.isEnabled = false
                self.dismiss(animated: true)
                
            } else {
                let alertController = UIAlertController(title: "失敗", message:
                    "儲存失敗，請確認輸入資料否正確！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }

    //將UIImage轉成Base64編碼格式
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
