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
                "email": self.email.text ?? "",
                "password": self.password.text ?? ""
            ],
            completion: self.writeModelAndGoToNext(data:))
    }
    
    private func writeModelAndGoToNext(data: Data?) {
        do {
            var account_scope: NSDictionary?
            var docs: NSArray?
            // dataをJSONパースし、変数"getJson"に格納
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let login : Bool = (json as! NSDictionary)["login"] as! Bool
            if login {
                docs = (json as! NSDictionary)["docs"] as? NSArray
                account_scope = (json as! NSDictionary)["account"] as? NSDictionary
                
                self.userDefaults.set(true, forKey: "login")
            } else {
                self.email.text = "error!!"
            }
            let realm = try! Realm()
            let user = User()
            user.userid = account_scope!["_id"] as! String
            user.accountname = account_scope!["accountname"] as! String
            user.password = account_scope!["password"] as! String
            user.email = account_scope!["email"] as! String
            try realm.write {
                realm.add(user)
            }

            let todoItems: Results<TodoItem> = realm.objects(TodoItem.self)

            for doc in docs! {
                let item = TodoItem()
                item.itemid = (doc as! NSDictionary)["itemid"] as! String
                print(item.itemid)
                item.accountname = (doc as! NSDictionary)["accountname"] as! String
                item.userid = (doc as! NSDictionary)["userid"] as! String

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
            DispatchQueue.main.async {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: false, completion: nil)

            }
        } catch {
            print ("json error")
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
