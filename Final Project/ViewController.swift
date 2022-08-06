//
//  ViewController.swift
//  Final Project
//
//  Created by Jin Hu on 7/4/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventsObjects:[EventObject] = []
    var newFlag = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let fileURL = dataFileURL()
        print(fileURL)
        
        if (FileManager.default.fileExists(atPath: fileURL.path)) {
            print("found file")
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                eventsObjects = try decoder.decode(Array<EventObject>.self, from: data)
            } catch {
                print("error finding file")
            }
        } else {
            print("file not found - load initial data")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name:UIApplication.willResignActiveNotification, object: nil)
    }
    
    @IBAction func newPressed(_ sender: UIButton) {
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
        if sender.currentTitle == "Edit" {
            sender.setTitle("Done", for: .normal)
        } else if sender.currentTitle == "Done" {
            sender.setTitle("Edit", for: .normal)
        } else {
            sender.setTitle("Done", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let recordToBeMoved = eventsObjects[sourceIndexPath.row]
        eventsObjects.remove(at: sourceIndexPath.row)
        eventsObjects.insert(recordToBeMoved, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath) {
        if editingStyle == .delete {
            eventsObjects.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let record = eventsObjects[indexPath.row]
        
        cell.textLabel!.text = record.name
        cell.detailTextLabel!.text = record.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsObjects.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = (segue.destination as! DateViewController)
        controller.masterViewController = self
        
        if segue.identifier == "showEventDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.itemIndex = indexPath.row
                newFlag = false
            }
        } else {
            controller.itemIndex = 0
            let newEvent = EventObject()
            eventsObjects.insert(newEvent, at: 0)
            newFlag = true
            tableView.reloadData()
        }
    }
    
    func dataFileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url:URL?
        url = URL(fileURLWithPath: "")
        url = urls.first!.appendingPathComponent("data.json")
        return url!
    }
    
    @objc func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self.eventsObjects) {
            do {
                try data.write(to: fileURL)
                print("wrote data using coding")
            } catch {
                print("error writing to data file")
            }
        }
    }
}
