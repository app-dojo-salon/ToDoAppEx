//
//  ViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
	private var todoList: Results<TodoItem>!
	private var token: NotificationToken?

	@IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		print(#function)

        // ToDoListをRealmから取得してオブザーバーを仕掛ける
        setTodoListConfig()

        // TableViewの設定メソッド
        setTableViewConfig()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print(#function)

		reload()
	}

	deinit {
        if let token = self.token {
            token.invalidate()
        }
	}
}


extension HomeViewController {
    /// 吹き出しメニューを作成する
    private func makeContextMenu(index: Int) -> UIMenu {
        let edit = UIAction(title: "編集", image: UIImage(systemName: "figure.wave")) { action in
            print("編集")
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            editVC.configure(type: .edit(index: index))
            self.present(editVC, animated: true, completion: nil)
        }

        let delete = UIAction(title: "削除", image: UIImage(systemName: "bag")) { action in
            print("削除")
            self.deleteServerData(index: index)
            RealmManager.shared.deleteItem(item: self.todoList[index])
        }

        return UIMenu(title: "Menu", children: [edit, delete])
    }

    private func deleteServerData(index: Int) {
        let targetItem = todoList[index]
        let serverRequest: ServerRequest = ServerRequest()

        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/delete_item",
            params: [
                "itemid": targetItem.itemid,
                "userid": targetItem.userid,
            ],
            completion: { (data: Data) -> Void in }
        )
    }

    private func setTodoListConfig() {
        todoList = RealmManager.shared.getItemInRealm(type: TodoItem.self)
        token = todoList.observe { [weak self] _ in
          self?.reload()
        }
    }

    private func setTableViewConfig() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")

        // セルの高さを固定
        tableView.estimatedRowHeight = 100
        // 区切り線を左端まで伸ばす
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.reloadData()
    }

    private func deleteTodoItem(at index: Int) {
        RealmManager.shared.deleteItem(item: todoList[index])
    }

    private func changeStatusToDoItem(index: Int) {
        RealmManager.shared.changeStatusToDoItem(type: TodoItem.self, uuid: todoList[index].itemid)
        reload()
    }

    private func reload() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoList == nil {
            return 0
        } else {
            return todoList.count
        }
	}

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.row
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { suggestedActions in
            return self.makeContextMenu(index: index)
        })
    }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
		// カスタムセルにRealmの情報を反映
		cell.configure(image: todoList[indexPath.row].image,
					   title: todoList[indexPath.row].title,
                       category: todoList[indexPath.row].category,
                       startDate: todoList[indexPath.row].startdate,
                       endDate: todoList[indexPath.row].enddate,
                       status: todoList[indexPath.row].status)
		return cell
	}

    // ToDoのステータス状態を変更するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeStatusToDoItem(index: indexPath.row)
    }

}
