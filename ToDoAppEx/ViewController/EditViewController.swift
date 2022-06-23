//
//  EditViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit

class EditViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var endDateTime: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }

    func setToDoItem(list: String, category: String) -> TodoItem {
        let toDo = TodoItem()
        let users = RealmManager.shared.getItemInRealm(type: User.self)
        let uuid = UUID()
        let date = Date()
        toDo.itemid = uuid.uuidString
        // FIXME: アカウントは仮でyoshikiの固定値
        toDo.accountname = users[0].accountname
        // FIXME: 現状は画像の種類が一枚なので固定値
        toDo.image = "check"
        toDo.title = list
        toDo.category = category
        toDo.startdate = startDateTime.date.toStringWithCurrentLocale().description
        toDo.enddate = endDateTime.date.toStringWithCurrentLocale().description
        textField.text = ""

        return toDo
    }

	@IBAction func tapAddButton(_ sender: Any) {
        guard let newList = textField.text, !newList.isEmpty else { return }
        guard let newCategory = categoryTextField.text, !newCategory.isEmpty else { return }

        let toDo = setToDoItem(list: newList, category: newCategory)

        RealmManager.shared.writeItem(toDo)

        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/insert_item",
            params: [
                "itemid": toDo.itemid,
                "accountname": toDo.accountname,
                "title": toDo.title,
                "category": toDo.category,
                "startdate": toDo.startdate,
                "enddate": toDo.enddate,
                "image": toDo.image,
                "status": toDo.status
            ],
            completion: self.goToNext(data:)
        )
    }
    
    private func goToNext(data: Data?) {
        DispatchQueue.main.async {
            let UINavigationController = self.tabBarController?.viewControllers?[1]
            self.tabBarController?.selectedViewController = UINavigationController

        }
    }
}
