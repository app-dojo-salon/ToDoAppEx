//
//  EditViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

// 編集画面のタイプを管理するEnum
enum EditType {
    case create
    case edit(index: Int)
}

class EditViewController: UIViewController {
    private var type = EditType.create

	@IBOutlet weak var textField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var endDateTime: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        switch type {
        case .create:
            print("新規作成の編集画面を構成")
        case let .edit(index):
            print("既存タスク編集の編集画面を構成")
            addButton.setTitle("保存", for: .normal)
            let todoList = RealmManager.shared.getItemInRealm(type: TodoItem.self)
            setEditToDoItem(index: index, targetItem: todoList[index])
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // 編集画面をボトムナビゲーションかホーム画面からかによって処理を分ける
    func configure(type: EditType) {
        self.type = type
    }

    func setEditToDoItem(index: Int, targetItem: TodoItem) {
        textField.text = targetItem.title
        categoryTextField.text = targetItem.category
        startDateTime.date = targetItem.startdate.dateFromString(format: "yyyy/MM/dd HH:mm:ss")
        endDateTime.date = targetItem.enddate.dateFromString(format: "yyyy/MM/dd HH:mm:ss")
    }

    func editToDoItem(title: String, category: String, index: Int) {
        let item = ItemData(title: title,
                            category: category,
                            startDate: startDateTime.date.toStringWithCurrentLocale().description,
                            endDate: endDateTime.date.toStringWithCurrentLocale().description)

        RealmManager.shared.editToDoItem(item: item, index: index)
    }

    func createToDoItem(title: String, category: String) -> TodoItem {
        let toDo = TodoItem()
        let users = try! Realm().objects(User.self)
        let uuid = UUID()
        toDo.itemid = uuid.uuidString
        // FIXME: アカウントは仮でyoshikiの固定値
        toDo.accountname = users[0].accountname
        toDo.userid = users[0].userid
        // FIXME: 現状は画像の種類が一枚なので固定値
        toDo.image = "check"
        toDo.title = title
        toDo.category = category
        toDo.startdate = startDateTime.date.toStringWithCurrentLocale().description
        toDo.enddate = endDateTime.date.toStringWithCurrentLocale().description
        textField.text = ""

        return toDo
    }

	@IBAction func tapAddButton(_ sender: Any) {
        guard let newTitle = textField.text, !newTitle.isEmpty else { return }
        guard let newCategory = categoryTextField.text, !newCategory.isEmpty else { return }

        switch type {
        case .create:
            let toDo = createToDoItem(title: newTitle, category: newCategory)
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.add(toDo)
                }
            } catch {
                print("アイテム書き込み失敗")
            }
            let serverRequest: ServerRequest = ServerRequest()

            serverRequest.sendServerRequest(
                urlString: "http://tk2-235-27465.vs.sakura.ne.jp/insert_item",
                params: [
                    "itemid": toDo.itemid,
                    "accountname": toDo.accountname,
                    "userid": toDo.userid,
                    "title": toDo.title,
                    "category": toDo.category,
                    "startdate": toDo.startdate,
                    "enddate": toDo.enddate,
                    "image": toDo.image,
                    "status": toDo.status
                ],
                completion: self.goToNext(data:)
            )
        case .edit(let index):
            editToDoItem(title: newTitle, category: newCategory, index: index)

            let serverRequest: ServerRequest = ServerRequest()
            let todoList = RealmManager.shared.getItemInRealm(type: TodoItem.self)
            let targetItem = todoList[index]

            serverRequest.sendServerRequest(
                urlString: "http://tk2-235-27465.vs.sakura.ne.jp/insert_item",
                params: [
                    "itemid": targetItem.itemid,
                    "accountname": targetItem.accountname,
                    "userid": targetItem.userid,
                    "title": targetItem.title,
                    "category": targetItem.category,
                    "startdate": targetItem.startdate,
                    "enddate": targetItem.enddate,
                    "image": targetItem.image,
                    "status": targetItem.status
                ],
                completion: self.closeScreen(data:)
            )
        }
    }
    
    private func goToNext(data: Data?) {
        DispatchQueue.main.async {
            let UINavigationController = self.tabBarController?.viewControllers?[1]
            self.tabBarController?.selectedViewController = UINavigationController
        }
    }

    private func closeScreen(data: Data?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// 編集するToDoItemの情報を管理
struct ItemData {
    let title: String
    let category: String
    let startDate: String
    let endDate: String
}
