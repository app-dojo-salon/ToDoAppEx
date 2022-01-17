//
//  ShareTodoItemCell.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/12/30.
//

import UIKit

class ShareTodoItemCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    func configure(taskName: String) {
        taskNameLabel.text = taskName
    }
}
