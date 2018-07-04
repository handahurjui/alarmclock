//
//  AlarmTableViewController.swift
//  AlarmClock
//
//  Created by andah on 03/07/2018.
//  Copyright © 2018 andah. All rights reserved.
//

import UIKit
import MBProgressHUD

class AlarmTableViewController: UITableViewController {

    var alarms: [Alarm] = []
//        [Alarm(id: 1, label: "Alarm1", hour: 12, minutes: 12, enabled: false),Alarm(id: 2, label: "Alarm2", hour: 14, minutes: 14, enabled: true),Alarm(id: 3, label: "Alarm3", hour: 14, minutes: 47, enabled: false)]
    let apiClient = NetworkClient()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading.."
        apiClient.getAlarms { [weak self] (alarms, error) in
            if let alarms = alarms {
                self?.alarms = alarms
                if alarms.count != 0 {
                    self?.navigationItem.leftBarButtonItem = self?.editButtonItem
                } else {
                    self?.navigationItem.leftBarButtonItem = nil
                }
                self?.tableView.reloadData()
                MBProgressHUD.hide(for: (self?.view)! , animated: true)
            } else {

                print("Error ")
            }
        }
        
        // for testing when no internet connection
//        self.alarms  = [Alarm(id: 1, label: "Alarm1", hour: 12, minutes: 12, enabled: true,token: "asadssadf"),Alarm(id: 2, label: "Alarm2", hour: 14, minutes: 14, enabled: true,token: "asadssadf"),Alarm(id: 3, label: "Alarm3", hour: 14, minutes: 47, enabled: false,token: "asadssadf")]
//        self.tableView.reloadData()
       
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if alarms.count == 0 {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
        return alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmTableViewCell
        

        // Configure the cell...
        cell.selectionStyle = . none
        cell.accessoryView = cell.enableSwitch
        cell.configureAlarmCellWithAlarm(alarms[indexPath.row])
        cell.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90 
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: "editSegue", sender: indexPath.row)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            apiClient.deleteAlarm(id: alarms[index].id)
            alarms.remove(at: index)
            if alarms.count == 0 {
                self.navigationItem.leftBarButtonItem = nil
            }
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! UINavigationController
        let addEditVC = destination.topViewController as! AddEditAlarmViewController
        if segue.identifier == "addSegue" {
            addEditVC.navigationItem.title = "Add Alarm"
            addEditVC.isEditMode = false
            addEditVC.cellIndex = alarms.count
//            addEditVC.alarm = Alarm(id: <#T##Int#>, label: <#T##String#>, hour: <#T##Int#>, minutes: <#T##Int#>, enabled: <#T##Bool#>, token: <#T##String#>)
        }
        else if segue.identifier == "editSegue" {
            addEditVC.navigationItem.title = "Edit Alarm"
            addEditVC.isEditMode = true
            addEditVC.cellIndex = sender as! Int
        }
    }
    @IBAction func unwindFromAddEditVC(_ segue: UIStoryboardSegue){
        isEditing = false 
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
extension AlarmTableViewController : AlarmTableViewCellDelegate {
    func alarmTableViewCellDidTouchSwitch(cell: AlarmTableViewCell, sender: UISwitch) {
        let index = tableView.indexPath(for: cell)
        alarms[(index?.row)!].enabled = sender.isOn
        apiClient.editAlarm(alarm: alarms[(index?.row)!])
        if sender.isOn {
            //PUT request
            print("switch on")
            
            tableView.reloadRows(at: [index!], with: .automatic)
        } else {
            //PUT request
            print("swithc is off")
            tableView.reloadRows(at: [index!], with: .automatic)
        }
       
    }
    
    
}
