//
//  TaskCell.swift
//  Harman_C0765590_labAssign2
//
//  Created by Harmanpreet Kaur on 2020-01-20.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

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
    
    func setTask(task: TaskModel){
        lblTitle.text = task.title

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormat.string(from: task.date)
        lblDate.text = formattedDate
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:MM:SS"
        let formattedTime = timeFormat.string(from: task.date)
        lblTime.text = formattedTime
        
        lblCompleteDays.text = "Days left: \(task.daysRequired - task.daysCompleted)"
    }

}
