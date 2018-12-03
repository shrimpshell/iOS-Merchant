//
//  AllRatingsUITableViewCell.swift
//  iOS-Merchant
//
//  Created by Una Lee on 2018/11/27.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class AllRatingsUITableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var idRoomReservationLabel: UILabel!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var allRating: Rating? {
        didSet {
            switch allRating?.ratingStatus {
            case 1:
                ratingStarView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                cellView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            case 2:
                cellView.backgroundColor = .white
                ratingStarView.backgroundColor = .white
            default:
                break
            }
            
            guard  let idRoomReservation = allRating?.idRoomReservation else {
                printHelper.println(tag: "AllRatingsUITableViewCell", line: #line, "Rating idRoomReservation is nil")
                return
            }
            if allRating?.idRoomReservation != nil {
                idRoomReservationLabel.text = "\(idRoomReservation)"
            } else {
                idRoomReservationLabel.text = ""
            }
            
            if allRating?.name != nil {
                customerNameLabel.text = allRating?.name
            }
            
            if allRating?.ratingStar != nil {
                ratingStarView.rating = Double((allRating?.ratingStar)!)
                ratingStarView.settings.updateOnTouch = false
            } else {
                ratingStarView.rating = 1
                ratingStarView.settings.updateOnTouch = false
            }
            
            if allRating?.opinion != nil {
                opinionLabel.text = allRating?.opinion
            } else {
                opinionLabel.isHidden = true
            }
            
            if allRating?.time != nil {
                dateLabel.text = allRating?.time
            } else {
                dateLabel.isHidden = true
            }
        }
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
