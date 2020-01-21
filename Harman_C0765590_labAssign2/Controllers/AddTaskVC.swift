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
    
    @IBOutlet weak var txtDescp: UITextView!
    @IBOutlet weak var txtDays: UITextField!
    
    var context: NSManagedObjectContext?
    
    weak var delegateTaskTVC: TasksTableViewController?
    weak var task: NSManagedObject?
    var segue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        if segue == "cellSegue"{
            txtTitle.isEnabled = false
            txtTitle.text = task?.value(forKey: "title") as! String
            txtDescp.text = task?.value(forKey: "descp") as! String
            txtDays.text = "\(task?.value(forKey: "daysRequired") as! Int)"
            navigationItem.title = "Edit"
            
        }
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tappedGesture)
        
    }

    @objc func tapped(){
        txtTitle.resignFirstResponder()
        txtDays.resignFirstResponder()
        txtDescp.resignFirstResponder()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        //returns if any field is empty
        guard !txtTitle.text!.isEmpty && !txtDescp.text!.isEmpty && !txtDays.text!.isEmpty else {
            okAlert(title: "Empty fields", message: "None of the field can be empty")
            return
        }
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context!.fetch(request)
            print("number of records...\(results.count)")
            
            var alreadyExists = false
            if results.count > 0{
                
                for r in results as! [NSManagedObject]{
                    let title = r.value(forKey: "title") as! String
                    if title == txtTitle.text{
                        alreadyExists = true
                        if segue == "cellSegue"{
                            r.setValue(txtTitle.text, forKey: "title")
                            r.setValue(txtDescp.text, forKey: "descp")
                            r.setValue(Int(txtDays.text ?? "1"), forKey: "daysRequired")
                            
                            saveData()
                        }
                    }
                }
                
            }
            if !alreadyExists{
                addNewTask()
            }
            else if alreadyExists && segue != "cellSegue"{
                okAlert(title: "Duplicate entry!", message: "Task named \(txtTitle.text!) already exists.")
            }
            
        }catch{
            print("Loading error....\(error)")
        }
        
        clearFields()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func clearFields(){
        txtTitle.text = ""
        txtDays.text = ""
        txtDescp.text = ""
    }
    
    func addNewTask(){
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context!)
        newTask.setValue(txtTitle.text, forKey: "title")
        newTask.setValue(txtDescp.text, forKey: "descp")
        newTask.setValue(Int(txtDays.text ?? "1"), forKey: "daysRequired")
        newTask.setValue(0, forKey: "daysCompleted")
        newTask.setValue(Date(), forKey: "date")
        saveData()
    }
    
    func saveData(){
        do{
            try context!.save()
        }catch{
            print("Saving error...\(error)")
        }
    }
    
    func okAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        okAction.setValue( #colorLiteral(red: 0.6705882353, green: 0.3411764706, blue: 0.2470588235, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
