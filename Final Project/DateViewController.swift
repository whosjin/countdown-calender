//
//  DateViewController.swift
//  Final Project
//
//  Created by Jin Hu on 7/4/22.
//

import UIKit

class DateViewController: UIViewController {
    
    var masterViewController: ViewController!
    var itemIndex = 0
    var datesRemaining = " "

    @IBOutlet weak var textEvent: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        datePicker.datePickerMode =  .date
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        masterViewController.eventsObjects[itemIndex].name = textEvent.text!
        masterViewController.eventsObjects[itemIndex].date = datesRemaining
        masterViewController.tableView.reloadData()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        if masterViewController.newFlag {
            masterViewController.eventsObjects.remove(at: itemIndex)
            masterViewController.tableView.reloadData()
            masterViewController.newFlag = false
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let future = datePicker.date
         guard let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { return }
         
         let difference = Calendar.current.dateComponents([.day], from: today, to: future)
         guard let days = difference.day else { return }
         let ess = days > 1 ? "s" : ""
        datesRemaining = "\(days) day\(ess) away"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textEvent.text = masterViewController.eventsObjects[itemIndex].name
    }
}
