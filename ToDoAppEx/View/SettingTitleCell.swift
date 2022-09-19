//
//  SettingTitleCell.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2022/09/19.
//

import UIKit

class SettingTitleCell: UITableViewCell {

    @IBOutlet weak var settingTitleLabel: UILabel!
    func configure(titleName: String) {
        self.settingTitleLabel.text = titleName
    }

}
