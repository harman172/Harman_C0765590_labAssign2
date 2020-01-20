//
//  TaskModel.swift
//  Harman_C0765590_labAssign2
//
//  Created by Harmanpreet Kaur on 2020-01-20.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import Foundation

class TaskModel{
    internal init(title: String, description: String, daysRequired: Int, daysCompleted: Int) {
        self.title = title
        self.description = description
        self.daysRequired = daysRequired
        self.daysCompleted = daysCompleted
    }
    
    var title: String
    var description: String
    var daysRequired: Int
    var daysCompleted: Int
    
    
}
