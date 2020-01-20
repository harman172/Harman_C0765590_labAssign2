//
//  AddTaskVC.swift
//  Harman_C0765590_labAssign2
//
//  Created by Harmanpreet Kaur on 2020-01-19.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class AddTaskVC: UIViewController {

    var tasks: [TaskModel]?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtDays: UITextField!
    
    var context: NSManagedObjectContext?
    weak var delegateTaskTVC: TasksTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context!.fetch(request)
            print("number of records...\(results.count)")
            
            var alreadyExists = false
            if results.count > 0{
                
                for r in results as! [NSManagedObject]{
//                    context!.delete(r)
//                    saveData()
                    let title = r.value(forKey: "title") as! String
                    if title == txtTitle.text{
                        alreadyExists = true
                    }
                }
                
            }
            if !alreadyExists{
                print("Array count 1...\(tasks!.count)")
                addNewTask()
                loadData()
                print("Array count 2...\(tasks!.count)")

                
            }
            else{
                print("Task Already exists")
            }
            print("after save...\(results.count)")
            
        }catch{
            print("Loading error....\(error)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegateTaskTVC?.tasks = self.tasks
    
    }
    
    func addNewTask(){
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context!)
        newTask.setValue(txtTitle.text, forKey: "title")
        newTask.setValue(txtDescription.text, forKey: "descp")
        newTask.setValue(Int(txtDays.text ?? "1"), forKey: "daysRequired")
        newTask.setValue(0, forKey: "daysCompleted")
        saveData()
    }
    
    func saveData(){
        do{
            try context!.save()
        }catch{
            print("Saving error...\(error)")
        }
    }
    
    func loadData(){
        tasks = []
        // create an instance of app delegate
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
