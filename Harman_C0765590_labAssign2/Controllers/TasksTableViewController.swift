//
//  TasksTableViewController.swift
//  Harman_C0765590_labAssign2
//
//  Created by Harmanpreet Kaur on 2020-01-19.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, UISearchResultsUpdating {

    var tasks: [TaskModel]?

    @IBOutlet weak var lblSort: UIBarButtonItem!
    var managedContext: NSManagedObjectContext?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        
        lblSort.image = UIImage(systemName: "a.square.fill")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // second step is context
        managedContext = appDelegate.persistentContainer.viewContext
        
        tasks = []
        reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            
            guard !searchText.isEmpty else {
                return
            }
//            if searchText.isEmpty{
//                reloadData()
//            }else{
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

            fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", searchText.lowercased())
            
            do {
                
                let results = try managedContext!.fetch(fetchRequest)

                if results is [NSManagedObject] {
                    tasks = []
                    for result in results as! [NSManagedObject] {
                        let title = result.value(forKey: "title") as! String
                        let description = result.value(forKey: "descp") as! String
                        let daysRequired = result.value(forKey: "daysRequired") as! Int
                        let daysCompleted = result.value(forKey: "daysCompleted") as! Int
                        let date = result.value(forKey: "date") as! Date
                        
                        tasks?.append(TaskModel(title: title, description: description, daysRequired: daysRequired, daysCompleted: daysCompleted, date: date))
                    }
                }
            } catch {
                print(error)
            }
//            }
        }
        tableView.reloadData()
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(tasks![indexPath.row].title)
//    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do{
                let results = try self.managedContext!.fetch(request)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if self.tasks![indexPath.row].title == result.value(forKey: "title") as! String{
                            self.managedContext?.delete(result)
                            break
                        }
                    }
                    do{
                        try self.managedContext?.save()
                    } catch{
                        print(error)
                    }
                    
                }
//                self.reloadData()
//                self.tableView.reloadData()
                
            }catch{
                print(error)
            }
            
            self.tasks!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            print("Delete")
        })
        
        /*
        let addDayAction = UIContextualAction(style: .normal, title: "Add Day", handler: {(action, view, success) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do{
                let results = try self.managedContext!.fetch(request)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        
                        if self.tasks![indexPath.row].title == result.value(forKey: "title") as! String{
                            
                            if ((result.value(forKey: "daysCompleted") as! Int) < (result.value(forKey: "daysRequired") as! Int)){
                                let days = result.value(forKey: "daysCompleted") as! Int
                                result.setValue((days + 1), forKey: "daysCompleted")
                                break
                            }
    
                        }
                    }
                    do{
                        try self.managedContext?.save()
                    } catch{
                        print(error)
                    }
                }
            }catch{
                print(error)
            }
//            self.okAlert(title: "One day added", message: "Success!")
//            self.reloadData()
            self.tasks![indexPath.row].daysCompleted += 1
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        })
        addDayAction.backgroundColor = .brown
        */
        
        return UISwipeActionsConfiguration(actions: [DeleteAction])
    }
    
    func okAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (okSuccess) in
            self.tableView.reloadData()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, success) in
//
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
//            do{
//                let results = try managedContext?.fetch(request)
//
//            }
//        })
//
//
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//
//    }
    

    

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
            destination.segue = segue.identifier
            
            if let tableCell = sender as? TaskCell{
                if let index = tableView.indexPath(for: tableCell)?.row{
//                    destination.setData(task: tasks![index])
                    destination.task = tasks![index]
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        reloadData()
        tableView.reloadData()
        lblSort.image = UIImage(systemName: "a.square.fill")

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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext!.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for result in results as! [NSManagedObject] {
                    let title = result.value(forKey: "title") as! String
                    let description = result.value(forKey: "descp") as! String
                    let daysRequired = result.value(forKey: "daysRequired") as! Int
                    let daysCompleted = result.value(forKey: "daysCompleted") as! Int
                    let date = result.value(forKey: "date") as! Date
                    
                    tasks?.append(TaskModel(title: title, description: description, daysRequired: daysRequired, daysCompleted: daysCompleted, date: date))
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func btnSorting(_ sender: UIBarButtonItem) {
//        var title = sender.title!
        
//        sender.image = UIImage(systemName: "a.square.fill")
        
//        print(image?.value(forKey: "system"))
        
        if sender.image == UIImage(systemName: "a.square.fill"){
            tasks!.sort(by: { $0.title.lowercased() < $1.title.lowercased() })
            sender.image = UIImage(systemName: "calendar")
        }
        else if sender.image == UIImage(systemName: "calendar"){
            tasks!.sort(by: { $0.date < $1.date })
            sender.image = UIImage(systemName: "a.square.fill")

        }
        
//        if title == "By name"{
//            tasks!.sort(by: { $0.title.lowercased() < $1.title.lowercased() })
//            sender.title = "By date"
//        } else if sender.title == "By date"{
//            tasks!.sort(by: { $0.date < $1.date })
//            sender.title = "By name"
//        }
        tableView.reloadData()
    }
    
}
