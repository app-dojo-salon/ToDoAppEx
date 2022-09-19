//
//  SettingViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {

    enum SystemName: Int {
        case userInfo = 0
        case accountName = 1
        case password = 2
        case email = 3
        case appliInfo = 4
        case version = 5
        case licence = 6
        case explain = 7
        case logout = 8
    }

    var systemNameArray: [SystemName: String] = [
        SystemName.userInfo: "ユーザー情報",
        SystemName.accountName: "ユーザー名",
        SystemName.password: "パスワード",
        SystemName.email: "メールアドレス",
        SystemName.appliInfo: "アプリ情報",
        SystemName.version: "バージョン",
        SystemName.licence: "ライセンス",
        SystemName.explain: "アプリ説明",
        SystemName.logout: "ステータス"
    ]
    
    var contentNameArray: [SystemName: String] = [
        SystemName.userInfo: "",
        SystemName.accountName: "",
        SystemName.password: "",
        SystemName.email: "",
        SystemName.appliInfo: "",
        SystemName.version: "1.0.0",
        SystemName.licence: "app-dojo-salon nao yoshiki",
        SystemName.explain: "サイトへのリンク",
        SystemName.logout: "ログイン状態",
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = RealmManager.shared.getItemInRealm(type: User.self)
        contentNameArray[SystemName.accountName] = user[0].accountname
        contentNameArray[SystemName.password] = user[0].password
        contentNameArray[SystemName.email] = user[0].email
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingTitleCell", bundle: nil), forCellReuseIdentifier: "SettingTitleCell")
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets.zero
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        systemNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == SystemName.userInfo.rawValue || indexPath.row == SystemName.appliInfo.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTitleCell", for: indexPath) as! SettingTitleCell
            cell.configure(titleName: systemNameArray[SystemName(rawValue: indexPath.row)!]!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            cell.configure(systemName: systemNameArray[SystemName(rawValue: indexPath.row)!]!, contentName: contentNameArray[SystemName(rawValue: indexPath.row)!]!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
