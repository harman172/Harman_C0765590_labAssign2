//
//  TasksTableViewController.swift
//  Harman_C0765590_labAssign2
//
//  Created by Harmanpreet Kaur on 2020-01-19.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {

    var tasks: [TaskModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tasks = []
        reloadData()
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
        return tasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
//            cell.textLabel?.text = tasks![indexPath.row].title
        cell.setTask(task: tasks![indexPath.row])
            return cell
//        }

        // Configure the cell...

//        return UITableViewCell()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? AddTaskVC{
            destination.delegateTaskTVC = self
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loaddata()
        tableView.reloadData()
    }

    func loaddata(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            request.returnsObjectsAsFaults = false
                    
            do{
                let results = try context.fetch(request)
                print("records TVC...\(results.count)")
                
    //            var alreadyExists = false
    //            if results.count > 0{
    //
    //                for r in results as! [NSManagedObject]{
    ////                    context!.delete(r)
    ////                    saveData()
    //                    let title = r.value(forKey: "title") as! String
    //                    if title == txtTitle.text{
    //                        alreadyExists = true
    //                    }
    //                }
    //
    //            }
    //            if !alreadyExists{
    //                addNewTask()
    //            }
    //            print("after save...\(results.count)")
                
            }catch{
                print("Loading error....\(error)")
            }
                
        }
    func reloadData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // second step is context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for result in results as! [NSManagedObject] {
                    let title = result.value(forKey: "title") as! String
                    let description = result.value(forKey: "description") as! String
                    let daysRequired = result.value(forKey: "daysRequired") as! Int
                    let daysCompleted = result.value(forKey: "daysCompleted") as! Int
                    
                    tasks?.append(TaskModel(title: title, description: description, daysRequired: daysRequired, daysCompleted: daysCompleted))
                }
            }
        } catch {
            print(error)
        }
    }
}
