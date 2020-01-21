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

//    var tasks: [TaskModel]?
    
    var tasksArray: [NSManagedObject]?

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
        
        loadData()
        print("count of array.....\(tasksArray?.count)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            
            guard !searchText.isEmpty else {
                loadData()
                tableView.reloadData()
                return
            }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

            fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", searchText.lowercased())
            
            do {
                
                let results = try managedContext!.fetch(fetchRequest)

                if results is [NSManagedObject] {
                    tasksArray = results as! [NSManagedObject]
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
        return tasksArray?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...

        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
        cell.setTask(task: tasksArray![indexPath.row])
        if (tasksArray![indexPath.row].value(forKey: "daysCompleted") as! Int) == (tasksArray![indexPath.row].value(forKey: "daysRequired") as! Int){
            cell.accessoryType = .checkmark
            cell.backgroundColor = .red
        } else{
            cell.accessoryType = .none
            cell.backgroundColor = .none
        }
        return cell

    }
  
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do{
                let results = try self.managedContext!.fetch(request)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        
                        if self.tasksArray![indexPath.row].value(forKey: "title") as! String == result.value(forKey: "title") as! String{
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
                
            }catch{
                print(error)
            }
            self.loadData()
            tableView.deleteRows(at: [indexPath], with: .fade)

        })
        
        let addDayAction = UIContextualAction(style: .normal, title: "Add Day", handler: {(action, view, success) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do{
                let results = try self.managedContext!.fetch(request)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        
                        if self.tasksArray![indexPath.row].value(forKey: "title") as! String == result.value(forKey: "title") as! String{
                            
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
            if self.lblSort.image == UIImage(systemName: "calendar"){
                self.sortByName()
            } else{
                self.loadData()
            }
            self.tableView.reloadData()
            
        })
        addDayAction.backgroundColor = .brown
        
        
        return UISwipeActionsConfiguration(actions: [DeleteAction, addDayAction])
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
            destination.segue = segue.identifier
            
            if let tableCell = sender as? TaskCell{
                if let index = tableView.indexPath(for: tableCell)?.row{
//                    destination.setData(task: tasks![index])
                    destination.task = tasksArray![index]
                    
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        reloadData()
        loadData()
        print("array count....\(tasksArray?.count)")
        tableView.reloadData()
        lblSort.image = UIImage(systemName: "a.square.fill")

    }

    func loadData(){
        tasksArray = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext!.fetch(fetchRequest)
            if results is [NSManagedObject] {
                tasksArray = results as! [NSManagedObject]
            }
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func btnSorting(_ sender: UIBarButtonItem) {

        if sender.image == UIImage(systemName: "a.square.fill"){
            sortByName()
            sender.image = UIImage(systemName: "calendar")
        }
        else if sender.image == UIImage(systemName: "calendar"){
            sortByDateTime()
            sender.image = UIImage(systemName: "a.square.fill")
        }

        tableView.reloadData()
    }
    
    func sortByName(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do{
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            let sorts = [sortDescriptor]
            request.sortDescriptors = sorts
            
            let sortByName = try managedContext!.fetch(request) as! [NSManagedObject]
            tasksArray = sortByName
            print("counttt...\(sortByName.count)")
            
        }catch{
            print(error)
        }
    }
    
    func sortByDateTime(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

        do{
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            let sorts = [sortDescriptor]
            request.sortDescriptors = sorts
            
            let sortByDate = try managedContext!.fetch(request) as! [NSManagedObject]
            tasksArray = sortByDate
            print("counttt...\(sortByDate.count)")
            
        }catch{
            print(error)
        }
    }
    
}
