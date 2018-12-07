//
//  EventDetailTableViewController.swift
//  iOS-Merchant
//
//  Created by Nick Wen on 2018/12/5.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class EventDetailTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var event: Event?
    let communicator = Communicator.shared
    var id = 0
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var discountTextFeild: UITextField!
    

    //IndexPath
    let startDateTitle = IndexPath(row: 0, section: 2)
    let endDateTitle = IndexPath(row: 0, section: 3)
    
    
    //控制項
    var startDateShown = true {
        didSet{
//            startDatePicker.isHidden = !startDateShown
        }
    }
    var endDateShown = true {
        didSet{
//            endDatePicker.isHidden = !endDateShown
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let  event = event {
//            nameTextField.text = event.name
//            startDateLabel.text = event.start
//            endDateLabel.text = event.end
//        }
        
        updateSaveButtonState()
        
        startDatePicker?.datePickerMode = .date
        endDatePicker?.datePickerMode = .date
        
        
        startDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @IBAction func textFieldBeginEditing(_ sender: Any) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState(){
        
        let name = nameTextField.text ?? ""
        let start = startDateLabel.text ?? ""
        let end = endDateLabel.text ?? ""
        let eventImage = self.eventImageView.image
        let discount = discountTextFeild.text ?? ""
        let description = descriptionTextView.text ?? ""
        
        
        let isNameExist = !name.isEmpty
        let isSDateExist = !start.isEmpty
        let isEDateExist = !end.isEmpty
        let isImageExist = !(eventImage?.isEqual(nil))!
        let isDiscount = !discount.isEmpty
        let isdescription = !description.isEmpty
        
        let shouldEnable = isNameExist &&
            isSDateExist &&
            isEDateExist &&
            isImageExist &&
            isDiscount &&
            isdescription
        saveBarButtonItem.isEnabled = shouldEnable
        
    }
    
    @objc func viewTapped(gestureRecognize: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        
        //自定義日期格式
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        
        let startDateValue = dateformatter.string(from: startDatePicker.date)
        let endDateValue = dateformatter.string(from: endDatePicker.date)
        
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: startDatePicker.date)
        
        
//        if startDateShown == true {
            startDateLabel.text = startDateValue
            startDateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
//        } else {
            endDateLabel.text = endDateValue
            endDateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.endEditing(true)
//        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath{
//        case startDateTitle:
//            tableView.beginUpdates()
//            if endDateShown && !startDateShown{
//                endDateShown = false
//            }
//            startDateShown = !startDateShown
//            tableView.endUpdates()
//        case endDateTitle:
//            tableView.beginUpdates()
//            if startDateShown && !endDateShown{
//                startDateShown = false
//            }
//            endDateShown = !endDateShown
//            tableView.endUpdates()
//        default:
//            break
//
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 針對開始日期的調整
        let activityImageIndexPath = IndexPath(row: 0, section: 0)
        let startDatePickerIndexPath = IndexPath(row: 1, section: 2)
        let endDatePickerIndexPath = IndexPath(row: 1, section: 3)
        
        if indexPath == activityImageIndexPath{
            return 90.0
        }
        else if indexPath == startDatePickerIndexPath{
            
            if startDateShown{
                
                return 216.0
            }else{
                return 0.0
            }
            
        } else if indexPath == endDatePickerIndexPath{
            
            if endDateShown{
                
                return 216.0
            }else{
                return 0.0
            }
        }
        return  44.0
    }
    
    @IBAction func pickPictureBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Please choose source:", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.launchPicker(source: .camera)
        }
        let library = UIAlertAction(title: "Photo library", style: .default) { (action) in
            self.launchPicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func launchPicker(source: UIImagePickerController.SourceType) {
        
        //Check if the source is valid or not?
        guard UIImagePickerController.isSourceTypeAvailable(source)
            else {
                print("Invalid source type")
                return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        //        picker.mediaTypes = ["public.image", "public.movie"]
        picker.mediaTypes = [kUTTypeImage] as [String]
        picker.sourceType = source
        
        
        present(picker, animated: true)
    }
    
    //MARK: - UIImagePickerControllerDelegate protocol Method.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("info: \(info)")
        guard let type = info[.mediaType] as? String  else {
            assertionFailure("Invalid type")
            return
        }
        if type == kUTTypeImage as String {
            guard let originalImage = info[.originalImage] as? UIImage else {
                assertionFailure("originalImage is nil.")
                return
            }
            let resizedImage = originalImage.resize(maxEdge: 1024)!
            let jpgData = resizedImage.jpegData(compressionQuality: 0.8)//壓縮率:0.0~1之間,為了品質一般都控制在0.7~0.8
            
            let pngData = resizedImage.pngData()
            print("jpgData: \(jpgData!.count)")
            print("pngData: \(pngData!.count)")
            
            
            eventImageView.image = resizedImage
            
            picker.dismiss(animated: true) //Important! 加這行picker才會把自己收起來
        }
        
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        
        guard let selectedImage = eventImageView.image else {
            print("Image not found!")
            return
        }
        
        let imageBase64 =  convertImageToBase64(image: selectedImage)
        
        let nameDB = nameTextField.text!
        let start = startDateLabel.text!
        let end = endDateLabel.text!
        let discount = discountTextFeild.text!
        let description = descriptionTextView.text!
        
        let discountDB = Double(discount)
        
        
        
        if self.event != nil {//修改活動
            let id = self.event?.eventId
            let event = Event(eventId: id!, discount: discountDB!, name: nameDB, description: description, start: start, end: end)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            guard let newsData = try? encoder.encode(event) else {
                assertionFailure("Cast Event to json is Fail.")
                return
            }
            
            print(String(data: newsData, encoding: .utf8)!)
            
            guard let eventString = String(data: newsData, encoding: .utf8) else {
                assertionFailure("Cast newsData to String is Fail.")
                return
            }
            
            //寫入資料庫
            communicator.eventUpdate(event: eventString, photo: imageBase64) { (result, error) in
                if let error = error {
                    print("Insert event fail: \(error)")
                    return
                }
                
                guard let updateStatus = result as? Int else {
                    assertionFailure("modify fail.")
                    return
                }
                
                if updateStatus == 1 {
                    //跳出成功視窗
                    let alertController = UIAlertController(title: "完成", message:
                        "儲存成功", preferredStyle: .alert)
                    //                let okBtn = UIAlertAction(title: "確認", style: .default,handler: { _ in
                    //                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventView") as! EventTableViewController
                    //                    self.present(VC, animated: true, completion: nil)
                    //                })
                    let okBtn = UIAlertAction(title: "確認", style: .default)
                    alertController.addAction(okBtn)
                    self.present(alertController, animated: true)
                    //儲存按鈕消失
                    self.saveBarButtonItem.isEnabled = false
                    
                } else {
                    let alertController = UIAlertController(title: "失敗", message:
                        "儲存失敗", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "確認", style: .default)
                    alertController.addAction(okBtn)
                    self.present(alertController, animated: true)
                }
            }
            
        } else {//新增活動
            
            let event = Event(eventId: id, discount: discountDB!, name: nameDB, description: description, start: start, end: end)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            guard let newsData = try? encoder.encode(event) else {
                assertionFailure("Cast Event to json is Fail.")
                return
            }
            
            print(String(data: newsData, encoding: .utf8)!)
            
            guard let eventString = String(data: newsData, encoding: .utf8) else {
                assertionFailure("Cast newsData to String is Fail.")
                return
            }
            
            //寫入資料庫
            communicator.eventInsert(event: eventString, photo: imageBase64) { (result, error) in
                if let error = error {
                    print("Insert event fail: \(error)")
                    return
                }
                
                guard let updateStatus = result as? Int else {
                    assertionFailure("modify fail.")
                    return
                }
                
                if updateStatus == 1 {
                    //跳出成功視窗
                    let alertController = UIAlertController(title: "完成", message:
                        "儲存成功", preferredStyle: .alert)
                    //                let okBtn = UIAlertAction(title: "確認", style: .default,handler: { _ in
                    //                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventView") as! EventTableViewController
                    //                    self.present(VC, animated: true, completion: nil)
                    //                })
                    let okBtn = UIAlertAction(title: "確認", style: .default)
                    alertController.addAction(okBtn)
                    self.present(alertController, animated: true)
                    //儲存按鈕消失
                    self.saveBarButtonItem.isEnabled = false
                    
                } else {
                    let alertController = UIAlertController(title: "失敗", message:
                        "儲存失敗", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "確認", style: .default)
                    alertController.addAction(okBtn)
                    self.present(alertController, animated: true)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "save" else
        { return }
        
        guard  nameTextField.text!.count > 0 else
        {return}
        
        let nameDB = nameTextField.text ?? ""
        let start = startDateLabel.text ?? ""
        let end = endDateLabel.text ?? ""
        
        
        let discount = discountTextFeild.text ?? "1"
        let description = descriptionTextView.text ?? ""
        
        let discountDB = Double(discount)
        
        event = Event(eventId: id, discount: discountDB!, name: nameDB, description: description, start: start, end: end)
        
    }
    

}
