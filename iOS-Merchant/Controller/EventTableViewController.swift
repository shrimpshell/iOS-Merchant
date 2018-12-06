//
//  EventTableViewController.swift
//  Event
//
//  Created by Lucy on 2018/11/14.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var events = [Event]()
    
    let communicator = Communicator.shared
    let PHOTO_URL = Common.SERVER_URL + "/EventServlet"
    @IBOutlet var eventsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //啟用 navigation 導覽列上的編輯 tableView 鈕
//        navigationItem.leftBarButtonItem = editButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "employee_home_background")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        //註冊通知
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
    
        if events.count == 0 {
            //取得活動訊息資訊（文字部分）
            communicator.getAllEvents{ (result, error) in
                if let error = error {
                    print(" Load Data Error: \(error)")
                    return
                }
                guard let result = result else {
                    print (" result is nil")
                    return
                }
                print("Load Data OK.")
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                    print(" Fail to generate jsonData.")
                    return
                }
                //解碼
                let decoder = JSONDecoder()
                guard let resultObject = try? decoder.decode([Event].self, from: jsonData) else {
                    print(" Fail to decode jsonData.")
                    return
                }
                for eventItem in resultObject {
                    self.events.append(eventItem)
                }
                
                
                DispatchQueue.main.async {
                    self.eventsTableView.reloadData()
                }
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        events.removeAll()
    }
    
    @objc func save() {
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    //dataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        
        let event = events[indexPath.row]
        let id = event.eventId
        
        communicator.getPhotoById(photoURL: self.PHOTO_URL, id: id) { (result, error) in
            
            guard let data = result else {
                return
            }
            
            if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                DispatchQueue.main.async {
                    cell.eventImageView.image = UIImage(data: data)
                }
                cell.nameLabel.text = event.name
                cell.startDateLabel.text = event.start
                cell.endDateLabel.text = event.end
            }
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete the row from the data source
            let event = events[indexPath.row]
//            let id = event.eventId
            events.remove(at: indexPath.row) //先砍資料再砍畫面
        
            let eventItem = event
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            guard let newsData = try? encoder.encode(eventItem) else {
                assertionFailure("Cast event to json is Fail.")
                return
            }
            
            print(String(data: newsData, encoding: .utf8)!)
            
            guard let eventString = String(data: newsData, encoding: .utf8) else {
                assertionFailure("Cast newsData to String is Fail.")
                return
            }
            
            //寫入資料庫
            communicator.eventRemove(event: eventString) { (result, error) in
                if let error = error {
                    print("Delete event fail: \(error)")
                    return
                }
                
                guard let updateStatus = result as? Int else {
                    assertionFailure("delete fail.")
                    return
                }
                
                if updateStatus == 1 {
                    //跳出成功視窗
                    let alertController = UIAlertController(title: "完成", message:
                        "刪除成功", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: .default,handler: nil))
                    self.present(alertController, animated: false, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "失敗", message:
                        "刪除失敗", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: .default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert {
            //             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    @IBAction func unwindToList(_ segue: UIStoryboardSegue) {
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 看看使用者選到了哪一個 indexPath
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let event = events[selectedIndexPath.row]
            
            // 取得下一頁
            let destination = segue.destination as!
            UINavigationController
            let eventDetailTableVC = destination.topViewController as! EventDetailTableViewController
            
            let id = event.eventId
            communicator.getPhotoById(photoURL: self.PHOTO_URL, id: id) { (result, error) in
                
                guard let data = result else {
                    return
                }
               
                DispatchQueue.main.async {
                    eventDetailTableVC.event = event
                    eventDetailTableVC.nameTextField.text = event.name
                    eventDetailTableVC.startDateLabel.text = event.start
                    eventDetailTableVC.startDatePicker.date = Helper.getDateFromString(strFormat: "yyyy-MM-dd", strDate: event.start)
                    eventDetailTableVC.endDateLabel.text = event.end
                    eventDetailTableVC.endDatePicker.date = Helper.getDateFromString(strFormat: "yyyy-MM-dd", strDate: event.end)
                    eventDetailTableVC.discountTextFeild.text = String(event.discount * 10)
                    eventDetailTableVC.descriptionTextView.text = event.description
                    eventDetailTableVC.eventImageView.image = UIImage(data: data)
                }
            }
        }
    }
    

}
