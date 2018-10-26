//
//  CheckoutTableViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit

class CheckoutTableViewController: UITableViewController {
    
    var reservation: [Reservation]?
    var delegate: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reservation?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "general") as! CheckoutTableViewCell
        cell.reservation = reservation?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 216
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "編號：\(reservation![indexPath.row].checkout[0].roomGroup)", message: "確定付款？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default) {
            (action) in
            let roomReservationStatus = self.reservation![indexPath.row].checkout[0].roomReservationStatus
            let newReservationStatus = Int(roomReservationStatus)! + 1
            let roomGroup = self.reservation![indexPath.row].checkout[0].roomGroup
            let updateReservationStatusParameters: [String : String] = ["action":"updateRoomReservationStatusById", "roomGroup":roomGroup, "roomReservationStatus":String(newReservationStatus)]
            let payment = OrderPaymentDeatil()
            payment.updateRoomReservationStatusById(updateReservationStatusParameters).done { (result) in
                print(result)
                
                if result == "0" {
                    print("修改失敗")
                } else {
                    print("修改成功")
                    let newRoomList: [OrderRoomDetail] = self.changeStatus(self.reservation![indexPath.row].checkout, status: result)
                    self.reservation![indexPath.row].checkout = newRoomList
                    self.tableView.reloadData()
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "取消", style: .destructive))
        present(alertController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        ((self.parent as! UINavigationController).viewControllers.first as! ProfileViewController).reservation = self.reservation!
        
    }

    func changeStatus(_ checkouts: [OrderRoomDetail], status: String) -> [OrderRoomDetail] {
        var finalRoomDetailList: [OrderRoomDetail] = checkouts
        for (index, _) in finalRoomDetailList.enumerated() {
            finalRoomDetailList[index].roomReservationStatus = status
        }
        return finalRoomDetailList
    }
}


