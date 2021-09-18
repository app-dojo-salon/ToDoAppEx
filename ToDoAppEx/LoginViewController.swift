//
//  LoginViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    let userDefaults = UserDefaults()
    @IBAction private func login(_ sender: Any) {
        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/login",
            params: [
                "email": self.email.text,
                "password": self.password.text
            ],
            completion: self.writeModelAndGoToNext(data:))
    }
    
    private func writeModelAndGoToNext(data: Data?) {
        do {
            // dataをJSONパースし、変数"getJson"に格納
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            DispatchQueue.main.async {
                let login : Bool = (json as! NSDictionary)["login"] as! Bool
                if login {
                    let realm = try! Realm()
                    let todoItems: Results<TodoItem> = realm.objects(TodoItem.self)

                    let docs : NSArray = (json as! NSDictionary)["docs"] as! NSArray
                    print(docs)
                    for doc in docs {
                        let item = TodoItem()
                        item.itemid = (doc as! NSDictionary)["itemid"] as! String
                        print(item.itemid)
                        item.accountname = (doc as! NSDictionary)["accountname"] as! String
                        
                        var existFlag = false
                        for todoitem in todoItems {
                            if todoitem.itemid == item.itemid && todoitem.accountname == item.accountname {
                                existFlag = true
                                break
                            }
                        }

                        if !existFlag {
                            item.category = (doc as! NSDictionary)["category"] as! String
                            item.image = (doc as! NSDictionary)["image"] as! String
                            item.title = (doc as! NSDictionary)["title"] as! String
                            item.startdate = (doc as! NSDictionary)["startdate"] as! String
                            item.enddate = (doc as! NSDictionary)["enddate"] as! String
                            try! realm.write {
                                realm.add(item)
                            }
                        }
                    }
                    
                    let allContents: Results<User> = realm.objects(User.self)

                    if allContents.count >= 1 {
                        try! realm.write {
                            allContents[0].accountname = self.email.text!
                            allContents[0].password = self.password.text!
                            print("ユーザーの上書き：\(allContents[0])")
                        }
                    } else {
                        let user = User()
                        user.accountname = self.email.text!
                        user.password = self.password.text!
                        try! realm.write {
                            realm.add(user)
                        }
                    }
                    self.userDefaults.set(true, forKey: "login")
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    secondViewController.modalPresentationStyle = .fullScreen
                    self.present(secondViewController, animated: false, completion: nil)
                } else {
                    self.email.text = "error!!"
                }
            }
        } catch {
            print ("json error")
            return
        }

    }
}
