//
//  EventTableViewController.swift
//  Event
//
//  Created by Lucy on 2018/11/14.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var events: [Event] = [
        Event(Events_Name: "room1", Events_Description: "this is room 1", discount: 0.9, Events_Start_Datetime: "2018-09-22 00:00:00", Events_End_Datetime: "2018-09-23 00:00:00", image: "4.jpeg"),
        Event(Events_Name: "event2", Events_Description: "this is event 2", discount: 0.8, Events_Start_Datetime: "2018-09-23 00:00:00", Events_End_Datetime: "2018-09-24 00:00:00", image: "2.png"),
        Event(Events_Name: "APP Shrimp", Events_Description: "use this app for discount", discount: 0.2, Events_Start_Datetime: "2018-09-30 00:00:00", Events_End_Datetime: "2018-10-23 00:00:00", image: "iTunesArtwork.png"),
        Event(Events_Name: "中秋限定！", Events_Description: "moon festival passed", discount: 0.5, Events_Start_Datetime: "2018-09-28 00:00:00", Events_End_Datetime: "2018-09-29 00:00:00", image: "3.jpeg"),
        Event(Events_Name: "秋季特價", Events_Description: "this is an event", discount: 0.9, Events_Start_Datetime: "2018-09-28 00:00:00", Events_End_Datetime: "2018-09-29 00:00:00", image: "5.jpeg"),
        Event(Events_Name: "聖誕歡慶", Events_Description: "歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠歡慶聖誕節，聖誕節期間限定優惠", discount: 0.7, Events_Start_Datetime: "2018-12-21 00:00:00", Events_End_Datetime: "2018-12-26 00:00:00", image: "6.jpg")
    ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell

        cell.nameLabel?.text = events[indexPath.row].Events_Name
        cell.descriptionLabel?.text = events[indexPath.row].Events_Description
        cell.eventImageView.image = UIImage(named: events[indexPath.row].image)

        return cell
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
