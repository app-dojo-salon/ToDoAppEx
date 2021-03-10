//
//  EditViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController, UINavigationBarDelegate, UITabBarDelegate {
	private var realm: Realm!
	private var todoList: Results<TodoItem>!
	private var token: NotificationToken!
    
    @IBOutlet private weak var navigationbar: UINavigationBar!
    @IBOutlet private weak var tabbar: UITabBar!
	@IBOutlet private weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationbar.delegate = self
		tabbar.delegate = self
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		realm = try! Realm()
		todoList = realm.objects(TodoItem.self)
		token = todoList.observe { [weak self] _ in
		  self?.reload()
		}
	}

    @IBAction func shareButton(_ sender: Any) {
        let shareVC = storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        shareVC.modalPresentationStyle = .fullScreen
        self.present(shareVC, animated: true, completion: nil)
    }

    @IBAction func searchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true, completion: nil)
    }

	@IBAction private func tappedAddButton(_ sender: Any) {
		let dlg = UIAlertController(title: "新規Todo", message: "",
									preferredStyle: .alert)
		dlg.addTextField(configurationHandler: nil)
		dlg.addAction(UIAlertAction(title: "OK", style: .default,
									handler: { action in
		  if let t = dlg.textFields![0].text,
			!t.isEmpty {
			self.addTodoItem(title: t)
		  }
		}))
		present(dlg, animated: true)
	}

	private func addTodoItem(title: String) {
		try! realm.write {
		  realm.add(TodoItem(value: ["title": title]))
		}
	}

	private func deleteTodoItem(at index: Int) {
		try! realm.write {
		  realm.delete(todoList[index])
		}
	}

	private func reload() {
		tableView.reloadData()
	}
	
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        } else if(item.tag == 2) {
            let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            settingVC.modalPresentationStyle = .fullScreen
            self.present(settingVC, animated: true, completion: nil)
        }
    }

	deinit {
		token.invalidate()
	}
}

extension EditViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath)
		cell.textLabel?.text = todoList[indexPath.row].title
		return cell
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		deleteTodoItem(at: indexPath.row)
	}
}

