//
//  SettingViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {

    var systemNameArray = [
        "ユーザー名",
        "パスワード",
        "メールアドレス",
        "ログアウト",
        "バージョン",
        "ライセンス",
        "アプリ説明"
    ]
    var contentNameArray = [
        "",
        "",
        "",
        "ログイン状態",
        "1.0.0",
        "app-dojo-salon nao yoshiki",
        "サイトへのリンク"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = RealmManager.shared.getItemInRealm(type: User.self)
        contentNameArray[0] = user[0].accountname
        contentNameArray[1] = user[0].password
        contentNameArray[2] = user[0].email
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets.zero
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        systemNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.configure(systemName: systemNameArray[indexPath.row], contentName: contentNameArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
