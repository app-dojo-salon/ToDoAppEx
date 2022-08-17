//
//  SearchViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var shareButton: UIBarButtonItem!
    // 検索結果を表示するtableView
    @IBOutlet weak var tableView: UITableView!
    // 現在表示される内容となるリスト
    private var todoList: Results<TodoItem>!
    private var token: NotificationToken?
    private var displayList: [TodoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.tintColor = UIColor.clear

        // 現在登録されているタスクの一覧を取得
        setTodoListConfig()

        // TableViewの設定メソッド
        setTableViewConfig()
    }

    deinit {
        if let token = self.token {
            token.invalidate()
        }
    }
}

extension SearchViewController {
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

    private func reload() {
        tableView.reloadData()
    }

    private func changeStatusToDoItem(index: Int) {
        RealmManager.shared.changeStatusToDoItem(type: TodoItem.self, uuid: displayList[index].itemid)
        reload()
    }
}

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
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
