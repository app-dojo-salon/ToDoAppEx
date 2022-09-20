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
        case userInfoEditButton = 4
        case appInfo = 5
        case version = 6
        case licence = 7
        case explain = 8
        case status = 9
        case logoutButton = 10
        
        var title: String {
            switch self {
            case .userInfo:
                return "ユーザー情報"
            case .accountName:
                return "ユーザー名"
            case .password:
                return "パスワード"
            case .email:
                return "メールアドレス"
            case .userInfoEditButton:
                return "ユーザー情報変更"
            case .appInfo:
                return "アプリ情報"
            case .version:
                return "バージョン"
            case .licence:
                return "ライセンス"
            case .explain:
                return "アプリ説明"
            case .status:
                return "ステータス"
            case .logoutButton:
                return "ログアウト"
            }
        }

    }

//    var systemNameArray: [SystemName: String] = [
//        SystemName.userInfo: "ユーザー情報",
//        SystemName.accountName: "ユーザー名",
//        SystemName.password: "パスワード",
//        SystemName.email: "メールアドレス",
//        SystemName.userInfoEditButton: "ユーザー情報変更",
//        SystemName.appliInfo: "アプリ情報",
//        SystemName.version: "バージョン",
//        SystemName.licence: "ライセンス",
//        SystemName.explain: "アプリ説明",
//        SystemName.logout: "ステータス",
//        SystemName.logoutButton: "ログアウト"
//    ]
    
    var contentNameArray: [SystemName: String] = [
        SystemName.userInfo: "",
        SystemName.accountName: "",
        SystemName.password: "",
        SystemName.email: "",
        SystemName.userInfoEditButton: "",
        SystemName.appInfo: "",
        SystemName.version: "1.0.0",
        SystemName.licence: "app-dojo-salon nao yoshiki",
        SystemName.explain: "サイトへのリンク",
        SystemName.status: "ログイン状態",
        SystemName.logoutButton: ""
    ]
    private let userDefaults = UserDefaults()
    private var email: UITextField?
    private var accountName: UITextField?
    private var password: UITextField?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let user = try! Realm().objects(User.self) //RealmManager.shared.getItemInRealm(type: User.self)
        contentNameArray[SystemName.accountName] = user[0].accountname
        contentNameArray[SystemName.password] = user[0].password
        contentNameArray[SystemName.email] = user[0].email
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingTitleCell", bundle: nil), forCellReuseIdentifier: "SettingTitleCell")
        tableView.register(UINib(nibName: "SettingButtonCell", bundle: nil), forCellReuseIdentifier: "SettingButtonCell")
        tableView.register(UINib(nibName: "SettingLabelCell", bundle: nil), forCellReuseIdentifier: "SettingLabelCell")
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets.zero
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == SystemName.userInfo.rawValue || indexPath.row == SystemName.appInfo.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTitleCell", for: indexPath) as! SettingTitleCell
            cell.configure(titleName: SystemName(rawValue: indexPath.row)!.title)
            return cell
        } else if indexPath.row == SystemName.userInfoEditButton.rawValue || indexPath.row == SystemName.logoutButton.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonCell", for: indexPath) as! SettingButtonCell
            if indexPath.row == SystemName.userInfoEditButton.rawValue {
                cell.configure(buttonName: SystemName(rawValue: indexPath.row)!.title, systemName: SystemName.userInfoEditButton, userInfoEdit: self.editUserInfo, logout: logout)
            } else if indexPath.row == SystemName.logoutButton.rawValue {
                cell.configure(buttonName: SystemName(rawValue: indexPath.row)!.title, systemName: SystemName.logoutButton, userInfoEdit: self.editUserInfo, logout: logout)
            }
            return cell
        } else if indexPath.row == SystemName.accountName.rawValue || indexPath.row == SystemName.email.rawValue || indexPath.row == SystemName.password.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            cell.configure(systemName: SystemName(rawValue: indexPath.row)!.title, contentName: contentNameArray[SystemName(rawValue: indexPath.row)!]!)
            if indexPath.row == SystemName.email.rawValue {
                email = cell.contentNameTextField
            }
            if indexPath.row == SystemName.accountName.rawValue {
                accountName = cell.contentNameTextField
            }
            if indexPath.row == SystemName.password.rawValue {
                password = cell.contentNameTextField
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingLabelCell", for: indexPath) as! SettingLabelCell
            cell.configure(systemName: SystemName(rawValue: indexPath.row)!.title, contentName: contentNameArray[SystemName(rawValue: indexPath.row)!]!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func editUserInfo() {
        let realm = try! Realm()
        let allContents: Results<User> = realm.objects(User.self)
        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/update_account",
            params: [
                "userid": allContents[0].userid,
                "password": password?.text,
                "email": email?.text,
                "accountname": accountName?.text,
                "publicprivate": allContents[0].publicprivate,
                "sharepassword": allContents[0].sharepassword
            ],
            completion: self.dismissScreen(data:))
    }
    
    func dismissScreen(data: Data?) {
        DispatchQueue.main.async {
            let list = try! Realm().objects(User.self)
            try! Realm().write {
                list[0].password = self.password!.text!
                list[0].email = self.email!.text!
                list[0].accountname = self.accountName!.text!
            }
            self.dismiss(animated: true)
        }
    }

    func logout() {
        DispatchQueue.main.async {
            self.userDefaults.set(false, forKey: "login")
            self.dismiss(animated: true)
        }
    }
}
