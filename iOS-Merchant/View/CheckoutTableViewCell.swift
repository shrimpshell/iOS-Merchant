//
//  CheckoutTableViewCell.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roomListLabel: UILabel!
    @IBOutlet weak var instantLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentBackground: UIView!
    var reservation: Reservation? {
        didSet {
            // 標籤綁定
            // 編號
            reservationLabel.text = reservation?.id
            reservationLabel.backgroundColor = .yellow
            
            statusLabel.textColor = .black
            dateLabel.textColor = .black
            roomListLabel.textColor = .black
            instantLabel.textColor = .black
            priceLabel.textColor = .black
            // 付款狀態
            switch reservation!.checkout[0].roomReservationStatus {
            case "3":
                statusLabel.text = "已付款"
                contentBackground.backgroundColor = .gray
            case "2":
                statusLabel.text = "待付款"
                contentBackground.backgroundColor = .green
            case "1":
                statusLabel.text = "未付款"
                contentBackground.backgroundColor = .yellow
            default:
                statusLabel.text = "未入住"
                statusLabel.textColor = .white
                dateLabel.textColor = .white
                roomListLabel.textColor = .white
                instantLabel.textColor = .white
                priceLabel.textColor = .white
                contentBackground.backgroundColor = .red
            }
            // 日期
            dateLabel.text = "\(reservation!.checkout[0].checkInDate.prefix(10)) - \(reservation!.checkout[0].checkOuntDate.prefix(10))"
            // 金額
            var price = 0
            var roomInfo: String = ""
            var instantInfo: String = ""
            var aMeal = 0
            var bMeal = 0
            var cMeal = 0
            for checkouts in ((reservation?.checkout)!) {
                price += Int(checkouts.price)! * Int(checkouts.roomQuantity)!
                roomInfo += "\(checkouts.RoomTypeName) x \(checkouts.roomQuantity) \n"
            }
            // 即時服務
            for instants in ((reservation?.instant)!) {
                if instants.instantPrice != nil && instants.quantity != nil && instants.instantTypeName != nil {
//                    instantInfo += "\(String(describing: instants.instantTypeName!)) x \(String(describing: instants.quantity!))\n"
                    switch instants.instantTypeName! {
                    case "A餐":
                        aMeal = aMeal + Int(instants.quantity!)!
                    case "B餐":
                        bMeal = bMeal + Int(instants.quantity!)!
                    case "C餐":
                        cMeal = cMeal + Int(instants.quantity!)!
                    default:
                        break
                    }
                    price += Int(instants.instantPrice!)! * Int(instants.quantity!)!
                }
            }
            roomListLabel.text = roomInfo
            instantLabel.text = "A餐：\(aMeal)\nB餐：\(bMeal)\nC餐：\(cMeal)"
            instantLabel.sizeToFit()
            priceLabel.text = "$\(price)"
            
            // 綁定Action 付款
            statusLabel.isUserInteractionEnabled = true
            let changePaymentStatus = UITapGestureRecognizer(target: self, action: #selector(changeStatus))
            statusLabel.addGestureRecognizer(changePaymentStatus)

        }
    }
    
    @objc
    func changeStatus() {
        print("\(self.reservationLabel.text!), \(String(describing: self.statusLabel.text!))")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
