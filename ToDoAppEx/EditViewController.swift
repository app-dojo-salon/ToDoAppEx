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
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var endDateTime: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBAction func tapAddButton(_ sender: Any) {
        guard let newList = textField.text,
              !newList.isEmpty else { return }
        guard let newCategory = categoryTextField.text,
              !newCategory.isEmpty else { return }

		let realm = try! Realm()


        let allContents: Results<TodoItem> = realm.objects(TodoItem.self)
        let users: Results<User> = realm.objects(User.self)

        let toDo = TodoItem()

        if 0 <= allContents.count {
            toDo.itemid = allContents.count + 1
        } else {
            toDo.itemid = 1
        }
        
        // FIXME: アカウントは仮でyoshikiの固定値
        toDo.accountname = users[0].accountname
		// FIXME: 現状は画像の種類が一枚なので固定値
		toDo.image = "check"
        toDo.title = newList
        toDo.category = newCategory
        toDo.startdate = startDateTime.date.toStringWithCurrentLocale().description
        toDo.enddate = endDateTime.date.toStringWithCurrentLocale().description
		try! realm.write {
			realm.add(toDo)
			print("新しいリスト追加：\(newList)")
		}
		textField.text = ""
        
        
        let urlString = "http://tk2-235-27465.vs.sakura.ne.jp/insert_item"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params:[String:Any] = [
            "itemid": toDo.itemid,
            "accountname": toDo.accountname,
            "title": toDo.title,
            "category": toDo.category,
            "startdate": toDo.startdate,
            "enddate": toDo.enddate,
            "image": toDo.image
        ]
        var errorFlag = false
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                if error != nil {
                    DispatchQueue.main.sync {
                        errorFlag = true
                        self.textField.text = "server error!!"
                        print(error.debugDescription)
                    }
                    return
                }
            })
            task.resume()
        }catch{
            self.textField.text = "server error!!"
            print("Error:\(error)")
            return
        }

        if errorFlag == false {
            self.textField.text = "success!!"
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
        return

        
	}
}

extension Date {

    func toStringWithCurrentLocale() -> String {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return formatter.string(from: self)
    }

}
