//
//  ShareTodoItemList.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/12/30.
//

import UIKit

class ShareTodoItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var shareAccountLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    var account: String!
    var shareTodoItems: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        shareAccountLabel.text = account

        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/getShareTodoItemList",
            params: [
                "email": self.account!
            ],
            completion: self.getShareTodoItemList(data:))

        tableView.dataSource = self
    }
    func getShareTodoItemList(data: Data?) {
        self.shareTodoItems = []
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            DispatchQueue.main.async {
                let share : Bool = (json as! NSDictionary)["share"] as! Bool
                if share {
                    let docs : NSArray = (json as! NSDictionary)["docs"] as! NSArray
                    for doc in docs {
                            let item = TodoItem()
                            item.category = (doc as! NSDictionary)["category"] as! String
                            item.image = (doc as! NSDictionary)["image"] as! String
                            item.title = (doc as! NSDictionary)["title"] as! String
                            item.startdate = (doc as! NSDictionary)["startdate"] as! String
                            item.enddate = (doc as! NSDictionary)["enddate"] as! String
                            self.shareTodoItems.append(item.title)
                    }
                } else {
                    self.shareTodoItems.append("パスワードが必要です")
                }
            }
        } catch {
            print ("json error")
            return
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    func configure(shareAccount: String) {
        account = shareAccount
    }
    @IBAction func tappedSendButton(_ sender: Any) {
        if passwordTextField.text != "" {
            let serverRequest: ServerRequest = ServerRequest()
            serverRequest.sendServerRequest(
                urlString: "http://tk2-235-27465.vs.sakura.ne.jp/getShareTodoItemListWithPassword",
                params: [
                    "email": self.account!,
                    "sharepassword": self.passwordTextField.text!
                ],
                completion: self.getShareTodoItemList(data:))
        }
    }
}

extension ShareTodoItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareTodoItems.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareTodoItem", for: indexPath) as! ShareTodoItemCell
        cell.configure(taskName: shareTodoItems[indexPath.row])
        return cell
    }
}
