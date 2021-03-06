//
//  ViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

	private var todoList: Results<TodoItem>!
	private var realm: Realm!
	private var token: NotificationToken!

	@IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		print(#function)

		tableView.dataSource = self
		realm = try! Realm()
		todoList = realm.objects(TodoItem.self)
		token = todoList.observe { [weak self] _ in
		  self?.reload()
		}
		tableView.reloadData()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print(#function)

		reload()
	}

	private func deleteTodoItem(at index: Int) {
		try! realm.write {
		  realm.delete(todoList[index])
		}
	}

	private func reload() {
		tableView.reloadData()
	}

	deinit {
		token.invalidate()
	}
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath) as! ImageCell
		// カスタムセルにRealmの情報を反映
		cell.configure(image: todoList[indexPath.row].image,
					   title: todoList[indexPath.row].title)
		return cell
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		deleteTodoItem(at: indexPath.row)
	}
}
