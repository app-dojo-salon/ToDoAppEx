//
//  SettingButtonCell.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2022/09/19.
//

import UIKit

class SettingButtonCell: UITableViewCell {

    @IBOutlet weak var settingButton: UIButton!
    
    func configure(buttonName: String) {
        settingButton.setTitle(buttonName, for: .normal)
    }

}
