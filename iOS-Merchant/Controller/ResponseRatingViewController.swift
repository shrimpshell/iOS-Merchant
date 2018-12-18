//
//  ResponseRatingViewController.swift
//  iOS-Merchant
//
//  Created by Una Lee on 2018/11/30.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class ResponseRatingViewController: UIViewController, UITextViewDelegate {
    
    var rating: Rating?
    let ratingPromiseKitAuth = RatingPromiseKitAuth()
    let ratingAuth = Common.shared
    
    
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var idRoomReservationLabel: UILabel!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var customerOpinionLabel: UITextView!
    @IBOutlet weak var serviceResponseLabel: UITextView!
    @IBOutlet weak var banImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRatingDetail()
        cornerRadius(view: serviceResponseLabel)
        serviceResponseLabel.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //送出客服回覆
    @IBAction func sendResponseBtn(_ sender: UIBarButtonItem) {
        if serviceResponseLabel.text != "" {
            let serviceResponse = serviceResponseLabel.text!
            guard let idRoomReservation = rating?.idRoomReservation else {
                return
            }
            let reviewRating = Rating(review: serviceResponse, ratingStatus: 2, idRoomReservation: idRoomReservation)
            //上傳rating
            updateReview(ratingData: reviewRating)
            self.performSegue(withIdentifier: "goToAllRatingTablePage", sender: self.sendResponseBtn)
            
        } else {
            showAlert(message: "回覆內容不可空白")
        }
        
    }
    
    
    @IBAction func deleteRatingBtn(_ sender: UIButton) {
        guard  let idRoomReservation = rating?.idRoomReservation else {
            printHelper.println(tag: "ResponseRatingViewController", line: #line, "idRoomReservation 解包錯誤")
            return
        }
        ratingAuth.deleteRating(idRoomReservation: idRoomReservation) { (result, error) in
            if let error = error {
                printHelper.println(tag: "RatingListTableViewController", line: #line, "Rating download error\(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: "RatingListTableViewController", line: #line, "result is nil.")
                return
            }
            printHelper.println(tag: "RatingListTableViewController", line: #line, "Retrive Rating List is OK: \(result)")
            if "\(result)" == "1" {
                self.banImageView.image = UIImage(named: "ban.png")
            }
        }
    
        self.performSegue(withIdentifier: "goToAllRatingTablePage", sender: self.sendResponseBtn)
    }
    
    //顯示評論內容
    func showRatingDetail() {
        guard  let idRoomReservation = rating?.idRoomReservation else {
            printHelper.println(tag: "ProfileViewController", line: #line, "Rating idRoomReservation is nil")
            print("Rating idRoomReservation is nil")
            return
        }
        if rating?.idRoomReservation != nil {
            idRoomReservationLabel.text = "\(idRoomReservation)"
        } else {
            idRoomReservationLabel.text = ""
        }
        if rating?.name != nil {
            customerNameLabel.text = rating?.name
        }
        if rating?.ratingStar != nil {
            ratingStarView.rating = Double((rating?.ratingStar)!)
            ratingStarView.settings.updateOnTouch = false
        } else {
            ratingStarView.rating = 1
            ratingStarView.settings.updateOnTouch = false
        }
        if rating?.opinion != nil {
            customerOpinionLabel.text = rating?.opinion
        } else {
            customerOpinionLabel.isHidden = true
        }
        
        if rating?.time != nil {
            dateLabel.text = rating?.time
        } else {
            dateLabel.isHidden = true
        }
        
        if rating?.review != nil {
            serviceResponseLabel.text = rating?.review
        }
        if rating?.ratingStatus == 3 {
            self.banImageView.image = UIImage(named: "ban.png")
        }
    }
    
    func updateReview(ratingData: Rating) {
        let editCustomerData = try! JSONEncoder().encode(ratingData)
        let customerString = String(data: editCustomerData, encoding: .utf8)
        let updateReview = ["action": "updateReview", "rating": customerString] as! [String:Any]
        ratingPromiseKitAuth.updatePromiseKitRatingReview(updateReview).done {
            (result) in
            if result != "0" {
                print("商家回覆評論成功：\(result)")
            } else {
                self.showAlert(message: "會員資料修改失敗")
            }
        }
    }
    
    //藏鍵盤
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
