//
//  EditViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!

	override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBAction func tapAddButton(_ sender: Any) {
		guard let newList = textField.text,
			  !newList.isEmpty else { return }

		let realm = try! Realm()
		let toDo = TodoItem()

		toDo.title = newList
		// FIXME: 現状は画像の種類が一枚なので固定値
		toDo.image = "check"

		try! realm.write {
			realm.add(toDo)
			print("新しいリスト追加：\(newList)")
		}
		textField.text = ""
	}
}

