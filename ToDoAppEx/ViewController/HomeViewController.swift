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
    func makeContextMenu() -> UIMenu {
        let fight = UIAction(title: "FIGHT", image: UIImage(systemName: "figure.wave")) { action in
            print("編集")
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            self.present(editVC, animated: true, completion: nil)
        }

        let bag = UIAction(title: "BAG", image: UIImage(systemName: "bag")) { action in
            print("bag")
        }

        let pokemon = UIAction(title: "POKEMON", image: UIImage(systemName: "hare")) { action in
            print("pokemon")
        }

        let run = UIAction(title: "RUN", image: UIImage(systemName: "figure.walk")) { action in
            print("run")
        }

        return UIMenu(title: "Menu", children: [fight, bag, pokemon, run])
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
        RealmManager.shared.changeStatusToDoItem(type: TodoItem.self, index: index)
        reload()
    }

    private func reload() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoList.count
	}

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu()
        })
    }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath) as! ImageCell
		// カスタムセルにRealmの情報を反映
		cell.configure(image: todoList[indexPath.row].image,
					   title: todoList[indexPath.row].title,
                       category: todoList[indexPath.row].category,
                       startDate: todoList[indexPath.row].startdate,
                       endDate: todoList[indexPath.row].enddate,
                       status: todoList[indexPath.row].status)
		return cell
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		deleteTodoItem(at: indexPath.row)
	}

    // ToDoのステータス状態を変更するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeStatusToDoItem(index: indexPath.row)
    }

}
