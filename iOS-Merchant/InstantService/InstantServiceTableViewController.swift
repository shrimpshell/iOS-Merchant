//
//  InstantServiceTableViewController.swift
//  iOS-Merchant
//
//  Created by Josh Hsieh on 2018/11/20.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit


class InstantServiceTableViewController: UITableViewController {

    var departmentId: Int?
    let download = Common.shared
    
    var arrayInstantStatusForImage: [String] = []
    var arrayInstantStatusForInfo: [String] = []
    var arrayInstantRoomNumber: [String] = []
    var arrayInstantType:[String] = []
    var arrayInstantQuantity:[String] = []
    var arrayInstantIdInstantDetail:[String] = []
    var instantStatus = [Instant]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print("Debug 5 >>>\(instantStatus)")
        
        for status in instantStatus {
            switch status.status {
            case 1:
                self.arrayInstantStatusForImage.append("icon_unfinish")
                self.arrayInstantStatusForInfo.append("1")
            case 2:
                self.arrayInstantStatusForImage.append("icon_playing")
                self.arrayInstantStatusForInfo.append("2")
            case 3:
                self.arrayInstantStatusForImage.append("icon_finish")
                self.arrayInstantStatusForInfo.append("3")
            default:
                break
            }
        }
        print("Debug 3 >>> \(arrayInstantStatusForInfo)")
        
        for type in instantStatus {
            switch type.idInstantType {
            case 1:
                self.arrayInstantType.append("A餐")
            case 2:
                self.arrayInstantType.append("B餐")
            case 3:
                self.arrayInstantType.append("C餐")
            case 4:
                self.arrayInstantType.append("機場接送")
            case 5:
                self.arrayInstantType.append("車站接送")
            case 6:
                self.arrayInstantType.append("高鐵接送")
            case 7:
                self.arrayInstantType.append("清潔服務")
            case 8:
                self.arrayInstantType.append("洗衣服務")
            case 9:
                self.arrayInstantType.append("枕頭備品")
            case 10:
                self.arrayInstantType.append("盥洗用具")
            default:
                break
            }
        }
        
        for quantity in instantStatus {
            self.arrayInstantQuantity.append(String(quantity.quantity))
        }
        
        for roomnumber in instantStatus {
            self.arrayInstantRoomNumber.append(roomnumber.roomNumber)
        }
        
        for idInstantDetail in instantStatus {
            self.arrayInstantIdInstantDetail.append(String(idInstantDetail.idInstantDetail))
        }
        
        tableView.reloadData()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return instantStatus.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceDetailTableViewCell

        // Configure the cell...
        
        cell.statusImage.image = UIImage(named: arrayInstantStatusForImage[indexPath.row])
        cell.statusLabelForRoomNumber.text = arrayInstantRoomNumber[indexPath.row]
        cell.statusLabelForServiceType.text = arrayInstantType[indexPath.row]
        cell.statusLabelForCount.text = arrayInstantQuantity[indexPath.row]
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceDetailTableViewCell
        
        guard let idInstantDetail = Int(arrayInstantIdInstantDetail[indexPath.row].description) else {
            return
        }
        
        guard let status = Int(arrayInstantStatusForInfo[indexPath.row].description) else {
            return
        }
    
        switch status {
        case 1:
            download.updateStatus(idInstantDetail: idInstantDetail, status: 2) { (result, error) in
                if let error = error {
                    print("UpdateStatus text error: \(error)")
                    return
                }
                print("UpdateStatus text OK: \(result!)")
            }
        case 2:
            download.updateStatus(idInstantDetail: idInstantDetail, status: 3) { (result, error) in
                if let error = error {
                    print("UpdateStatus text error: \(error)")
                    return
                }
                print("UpdateStatus text OK: \(result!)")
            }
        default:
            break
        }
        
    }
    
    func getServiceItem(idInstantService: Int) {
        download.getEmployeeStatus(idInstantService: idInstantService) { (result, error) in
            if let error = error {
                print("updateUserServiceStatus 2 error: \(error)")
                return
            }
            guard let result = result else {
                print("result is nil.")
                return
            }
            print("updateUserServiceStatus 2 Info is OK.")
            // Decode as [Instant]. 解碼下載下來的 json
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("updateUserServiceStatus 2 Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Instant].self, from: jsonData) else {
                print("updateUserServiceStatus 2 Fail to decode jsonData.")
                return
            }
            print("getEmployeeStatus 2 resultObject: \(resultObject)")
            
            self.instantStatus = resultObject
            
            
        }
    }


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
