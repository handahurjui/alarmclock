//
//  AlarmTableViewCell.swift
//  AlarmClock
//
//  Created by andah on 03/07/2018.
//  Copyright © 2018 andah. All rights reserved.
//

import UIKit

protocol AlarmTableViewCellDelegate: class {
    func alarmTableViewCellDidTouchSwitch(cell: AlarmTableViewCell, sender: UISwitch)
}

class AlarmTableViewCell: UITableViewCell {

    
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmTitle: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    weak var delegate: AlarmTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureAlarmCellWithAlarm(_ alarm : Alarm) {
        alarmTime.text = "\(alarm.hour)" + ":" + "\(alarm.minutes)"
        alarmTitle.text = alarm.label
//        enableSwitch.isEnabled = alarm.enabled!
        if alarm.enabled! {
            self.alarmTitle.textColor = .white
            self.alarmTime.textColor = .white
            self.alarmTime?.alpha = 1.0
            self.alarmTitle.alpha = 1.0
            self.enableSwitch.setOn(true, animated: true)
        } else {
            self.enableSwitch.setOn(false, animated: true)
            self.alarmTitle.textColor = .gray
            self.alarmTime.textColor = .gray
            self.alarmTime.alpha = 0.5
            self.alarmTitle.alpha = 0.5
        }
    }
    @IBAction func switchTapped(_ sender: UISwitch) {
        delegate?.alarmTableViewCellDidTouchSwitch(cell: self, sender: sender)

    }
    
    
}
