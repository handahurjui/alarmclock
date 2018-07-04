//
//  AddEditAlarmViewController.swift
//  AlarmClock
//
//  Created by andah on 04/07/2018.
//  Copyright © 2018 andah. All rights reserved.
//

import UIKit

class AddEditAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var alarm: Alarm?
    var isEditMode: Bool!
    var cellIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        tableView.backgroundColor = .black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        if isEditMode {
           
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if isEditMode {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "addEditCell")
        if (cell == nil ) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "addEditCell")
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Repeat"
                cell?.detailTextLabel?.text = "Never"
                cell?.accessoryType = .disclosureIndicator
            }
            else if indexPath.row == 1 {
                cell?.textLabel?.text = "Label"
                cell?.detailTextLabel?.text = "Alarm"
                cell?.accessoryType = .disclosureIndicator
            }
            else if indexPath.row == 2 {
                cell?.textLabel?.text = "Sound"
                cell?.detailTextLabel?.text = "Sencha"
                cell?.accessoryType = .disclosureIndicator
            }
            else if indexPath.row == 3 {
                cell?.textLabel?.text = "Snooze"
                
                let switchBtn = UISwitch(frame: CGRect())
                switchBtn.isOn = true
                switchBtn.addTarget(self, action: #selector(switchBtnTapped), for: .touchUpInside)
                cell?.accessoryView = switchBtn
            }
             cell?.textLabel?.textColor = .white
        }
        else if indexPath.section == 1 {
            cell = UITableViewCell(style: .default, reuseIdentifier: "deleteCell")
            cell?.textLabel?.text = "Delete Alarm"
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = .red
        }
        cell?.backgroundColor = .black
        return cell!
    }
    @objc func switchBtnTapped() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
