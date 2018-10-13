//
//  CheckoutTableViewController.swift
//  iOS-Merchant
//
//  Created by Hsin Hwang on 2018/10/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class CheckoutTableViewController: UITableViewController {
    var checkouts = [Checkout]()
    var instants = [Instant]()
    var reservation = [Reservation]()
    var delegate: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 假資料
        let one = Checkout(idRoomReservation: 2, roomGroup: "123", checkInDate: "2018-04-01 00:00:00", checkOuntDate: "2018-04-02 00:00:00", roomNumber: "204", price: 3800, roomTypeName: "山景標準雙人房", roomQuantity: 1, roomReservationStatus: "3", ratingStatus: 1)
        let two = Checkout(idRoomReservation: 6, roomGroup: "234", checkInDate: "2018-04-03 00:00:00", checkOuntDate: "2018-04-04 00:00:00", roomNumber: "503", price: 5400, roomTypeName: "山景精緻雙人房", roomQuantity: 1, roomReservationStatus: "1", ratingStatus: 1)
        let three = Checkout(idRoomReservation: 12, roomGroup: "234", checkInDate: "2018-04-03 00:00:00", checkOuntDate: "2018-04-04 00:00:00", roomNumber: "303", price: 3800, roomTypeName: "山景標準雙人房", roomQuantity: 1, roomReservationStatus: "1", ratingStatus: 2)
        let four = Checkout(idRoomReservation: 9, roomGroup: "345", checkInDate: "2018-04-04 00:00:00", checkOuntDate: "2018-04-05 00:00:00", roomNumber: "601", price: 8000, roomTypeName: "海景豪華雙人房", roomQuantity: 1, roomReservationStatus: "0", ratingStatus: 2)
        let five = Checkout(idRoomReservation: 15, roomGroup: "456", checkInDate: "2018-04-22 00:00:00", checkOuntDate: "2018-04-28 00:00:00", roomNumber: "504", price: 5800, roomTypeName: "海景精緻雙人房", roomQuantity: 1, roomReservationStatus: "1", ratingStatus: 0)
        let six = Checkout(idRoomReservation: 20, roomGroup: "567", checkInDate: "2018-09-23 00:00:00", checkOuntDate: "2018-09-26 00:00:00", roomNumber: "301", price: 4100, roomTypeName: "海景標準雙人房", roomQuantity: 1, roomReservationStatus: "1", ratingStatus: 0)
        
        checkouts += [one, two, three, four, five, six]
        
        let aMeal = Instant(name: "A餐", quantity: 2, price: 100, roomGroup: "123")
        let bMeal = Instant(name: "B餐", quantity: 1, price: 300, roomGroup: "567")
        let cMeal = Instant(name: "C餐", quantity: 4, price: 200, roomGroup: "234")
        
        instants += [aMeal, bMeal, cMeal]
        
        // 重構結構
        for checkout in checkouts {
            reservation.append(Reservation(id: checkout.roomGroup, checkout: [], instant: []))
        }
        reservation = reservation.removeDeuplicates()
        for (index, _) in reservation.enumerated() {
            for checkout in checkouts {
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reservation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "general") as! CheckoutTableViewCell
        cell.reservation = reservation[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 216
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "編號：\(reservation[indexPath.row].checkout[0].roomGroup)", message: "確定付款？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default) {
            (action) in
        })
        alertController.addAction(UIAlertAction(title: "取消", style: .destructive) {
            (action) in
        })
        present(alertController, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 216
//    }

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
