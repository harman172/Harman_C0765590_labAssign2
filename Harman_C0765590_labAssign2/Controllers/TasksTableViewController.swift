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
    
    var tasksArray: [NSManagedObject]?
    var filteredArray = [NSManagedObject]()
    var isSearching = false
    
    @IBOutlet weak var lblSort: UIBarButtonItem!
    var managedContext: NSManagedObjectContext?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //to search tasks
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        
        //bar button image to sort by name
        lblSort.image = UIImage(systemName: "a.square.fill")
        
        //for core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        loadData()
        tableView.backgroundColor = .lightGray
//        print("count of array.....\(tasksArray?.count)")
        
    }
    
    //updates table view after search completes
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            isSearching = true
            
            guard !searchText.isEmpty else {
                loadData()
                tableView.reloadData()
                isSearching = false
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

            fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", searchText.lowercased())
            
            do {
                let results = try managedContext!.fetch(fetchRequest)
                if results is [NSManagedObject] {
                    tasksArray = results as! [NSManagedObject]
                    filteredArray = results as! [NSManagedObject]
//                    isSearching = false
                }
            } catch {
                print(error)
            }
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
        
        // when task completes
        if (tasksArray![indexPath.row].value(forKey: "daysCompleted") as! Int) == (tasksArray![indexPath.row].value(forKey: "daysRequired") as! Int){
            cell.accessoryType = .checkmark
            cell.tintColor = .white
            cell.backgroundColor = #colorLiteral(red: 0.6705882353, green: 0.3411764706, blue: 0.2470588235, alpha: 1)
        }
        // task is incomplete yet
        else{
            cell.accessoryType = .none
            cell.backgroundColor = .lightGray
        }
        return cell

    }
  
    //for swipe actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //delete on swipe
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            
            //delete from core data
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
//            tableView.deleteRows(at: [indexPath], with: .fade)

            //delete from searching array
            if self.isSearching{
                print("is searching...")
                self.filteredArray.remove(at: indexPath.row)
                self.tasksArray = self.filteredArray
            } else{
                print("not searchingggg.....")
                self.loadData()
            }
            tableView.reloadData()
        })
        
        // to add a day on swipe
        let addDayAction = UIContextualAction(style: .normal, title: "Add Day", handler: {(action, view, success) in
            
            //updates day in core data
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
                    destination.task = tasksArray![index]
                    
                }
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
       loadData()
       tableView.reloadData()
       lblSort.image = UIImage(systemName: "a.square.fill")

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
