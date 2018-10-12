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
            // 付款狀態
            switch reservation?.checkout[0].roomReservationStatus {
            case "2":
                statusLabel.text = "已付款"
                statusLabel.backgroundColor = .green
            case "1":
                statusLabel.text = "待付款"
                statusLabel.backgroundColor = .yellow
            default:
                statusLabel.text = "未付款"
                statusLabel.backgroundColor = .red
            }
            // 日期
            dateLabel.text = "\(reservation!.checkout[0].checkInDate.prefix(10)) - \(reservation!.checkout[0].checkOuntDate.prefix(10))"
            // 金額
            var price = 0
            var roomInfo: String = ""
            for checkouts in (reservation?.checkout)! {
                price += checkouts.price
                roomInfo += "\(checkouts.roomTypeName) x \(checkouts.roomQuantity) \n"
            }
            roomListLabel.text = roomInfo
            priceLabel.text = "$\(price)"
            // 還差即時服務
            
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
