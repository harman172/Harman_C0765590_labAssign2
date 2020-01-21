//
//  TaskCell.swift
//  Harman_C0765590_labAssign2
//
//  Created by Harmanpreet Kaur on 2020-01-20.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class TaskCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCompleteDays: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTask(task: NSManagedObject){
        
        lblTitle.text = task.value(forKey: "title") as! String

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormat.string(from: task.value(forKey: "date") as! Date)
        lblDate.text = formattedDate

        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:MM:SS"
        let formattedTime = timeFormat.string(from: task.value(forKey: "date") as! Date)
        lblTime.text = formattedTime

        let completedDays = task.value(forKey: "daysCompleted") as! Int
        let requiredDays = task.value(forKey: "daysRequired") as! Int
        
        if completedDays < requiredDays{
            lblCompleteDays.text = "\(completedDays)/\(requiredDays) days completed"
            lblCompleteDays.textColor = #colorLiteral(red: 0.6705882353, green: 0.3411764706, blue: 0.2470588235, alpha: 1)
            lblCompleteDays.font = lblCompleteDays.font.withSize(14)
        } else{
            lblCompleteDays.text = "Task completed"
            lblCompleteDays.textColor = .white
            lblCompleteDays.font = lblCompleteDays.font.withSize(20)
        }
    }

}
