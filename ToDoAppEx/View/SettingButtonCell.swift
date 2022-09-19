//
//  SettingButtonCell.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2022/09/19.
//

import UIKit

class SettingButtonCell: UITableViewCell {

    @IBOutlet weak var settingButton: UIButton!
    
    var systemName: SettingViewController.SystemName?
    var userInfoEdit: (() -> Void)?
    var logout: (() -> Void)?
    func configure(buttonName: String, systemName: SettingViewController.SystemName, userInfoEdit: @escaping () -> Void, logout: @escaping () -> Void ) {
        settingButton.setTitle(buttonName, for: .normal)
        self.systemName = systemName
        self.userInfoEdit = userInfoEdit
        self.logout = logout
    }

    @IBAction func buttonTapped(_ sender: Any) {
        if systemName == SettingViewController.SystemName.userInfoEditButton {
            self.userInfoEdit!()
        } else if systemName == SettingViewController.SystemName.logoutButton {
            self.logout!()
        }
    }
}
