//
//  ShareAccountCell.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/11/17.
//

import UIKit

class ShareAccountCell: UITableViewCell {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    
    func configure(title: String) {
        accountNameLabel.text = title
        
        
    }
}
