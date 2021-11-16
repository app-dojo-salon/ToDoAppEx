//
//  ShareViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class ShareViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!

    var shareAccounts: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getShareAccounts(data: nil)
        tableView.dataSource = self
    }

    func getShareAccounts(data: Data?) {
        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/get_accounts",
            params: [:],
            completion: self.setShareAccounts(data:))
    }
    
    func setShareAccounts(data: Data?) {
        shareAccounts = []
        do {
            // dataをJSONパースし、変数"getJson"に格納
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            DispatchQueue.main.async {
//                let login : Bool = (json as! NSDictionary)["login"] as! Bool
//                if login {
//                    let realm = try! Realm()
//                    let todoItems: Results<TodoItem> = realm.objects(TodoItem.self)

                    let docs : NSArray = json as! NSArray
                    print(docs)
                    for doc in docs {
//                        let item = TodoItem()
//                        item.itemid = (doc as! NSDictionary)["itemid"] as! String
//                        print(item.itemid)
                        if ((doc as! NSDictionary)["publicprivate"] != nil && (doc as! NSDictionary)["publicprivate"] as! Bool == true) {
                            self.shareAccounts.append((doc as! NSDictionary)["accountname"] as! String)
                        }
                        
//                        var existFlag = false
//                        for todoitem in todoItems {
//                            if todoitem.itemid == item.itemid && todoitem.accountname == item.accountname {
//                                existFlag = true
//                                break
//                            }
//                        }
//
//                        if !existFlag {
//                            item.category = (doc as! NSDictionary)["category"] as! String
//                            item.image = (doc as! NSDictionary)["image"] as! String
//                            item.title = (doc as! NSDictionary)["title"] as! String
//                            item.startdate = (doc as! NSDictionary)["startdate"] as! String
//                            item.enddate = (doc as! NSDictionary)["enddate"] as! String
//                            try! realm.write {
//                                realm.add(item)
//                            }
//                        }
                    }
//
//                    let allContents: Results<User> = realm.objects(User.self)
//
//                    if allContents.count >= 1 {
//                        try! realm.write {
//                            allContents[0].accountname = self.email.text!
//                            allContents[0].password = self.password.text!
//                            print("ユーザーの上書き：\(allContents[0])")
//                        }
//                    } else {
//                        let user = User()
//                        user.accountname = self.email.text!
//                        user.password = self.password.text!
//                        try! realm.write {
//                            realm.add(user)
//                        }
//                    }
//                    self.userDefaults.set(true, forKey: "login")
//                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//                    secondViewController.modalPresentationStyle = .fullScreen
//                    self.present(secondViewController, animated: false, completion: nil)
//                } else {
//                    self.email.text = "error!!"
//                }
            }
        } catch {
            print ("json error")
            return
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if(item.tag == 0) {
//            let homeVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            homeVC.modalPresentationStyle = .fullScreen
//            self.present(homeVC, animated: true, completion: nil)
//        } else if(item.tag == 1) {
//            let editVC = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
//            editVC.modalPresentationStyle = .fullScreen
//            self.present(editVC, animated: true, completion: nil)
//        } else if(item.tag == 2) {
//            let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//            settingVC.modalPresentationStyle = .fullScreen
//            self.present(settingVC, animated: true, completion: nil)
//        }
//    }

    @IBAction func tappedShareButton(_ sender: Any) {
        let realm = try! Realm()
        let allContents: Results<User> = realm.objects(User.self)

        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/update_account",
            params: [
                "accountname": allContents[0].accountname,
                "password": allContents[0].password,
                "publicprivate": true,
                "sharepassword": ""

            ],
            completion: self.getShareAccounts(data:))

    }
    
}

extension ShareViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareAccounts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareAccount", for: indexPath) as! ShareAccountCell
        cell.configure(title: shareAccounts[indexPath.row])
        return cell
    }
    
}
