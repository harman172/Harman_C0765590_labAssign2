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
    @IBOutlet weak var lblTotalDays: UILabel!
    
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
        lblTotalDays.text = "Total days: \(task.daysRequired)"
        lblCompleteDays.text = "Days left: \(task.daysRequired - task.daysCompleted)"
    }

}
