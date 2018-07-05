//
//  EditLabelTableViewController.swift
//  AlarmClock
//
//  Created by andah on 05/07/2018.
//  Copyright © 2018 andah. All rights reserved.
//

import UIKit

protocol EditLabelTableViewControllerDelegate: class {
    
    func editLabelTableViewController(_ controller: EditLabelTableViewController, didFinishEditing item: Alarm)
}
class EditLabelTableViewController: UITableViewController , UITextFieldDelegate {

    var itemToEdit : Alarm?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    weak var delegate: EditLabelTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            textField.text = item.label
            doneBtn.isEnabled =  true
        }
        tableView.separatorColor = .gray
    }
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.label = textField.text!
            delegate?.editLabelTableViewController(self, didFinishEditing: itemToEdit)
        }
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range,in: oldText)
        let newText = oldText.replacingCharacters(in: stringRange!, with: string)
        if newText.isEmpty {
            doneBtn.isEnabled = false
        } else {
            doneBtn.isEnabled = true
        }
        return true
    }


}
