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

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtDays: UITextField!
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
                addNewTask()
            }
            print("after save...\(results.count)")
            
        }catch{
            print("Loading error....\(error)")
        }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
