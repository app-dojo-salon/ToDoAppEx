//
//  EditViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit

enum EditType {
    case create
    case edit
}

class EditViewController: UIViewController {
    private var type = EditType.create

	@IBOutlet weak var textField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var endDateTime: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        switch type {
        case .create:
            print("新規作成の編集画面を構成")
        case .edit:
            print("既存タスク編集の編集画面を構成")
            
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // 編集画面をボトムナビゲーションかホーム画面からかによって処理を分ける
    func configure(type: EditType) {
        self.type = type
    }

    func setToDoItem(list: String, category: String) -> TodoItem {
        let toDo = TodoItem()
        let users = RealmManager.shared.getItemInRealm(type: User.self)
        let uuid = UUID()
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
