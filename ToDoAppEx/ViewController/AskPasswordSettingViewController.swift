//
//  AskPasswordSettingViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2022/02/23.
//

import UIKit
import RealmSwift

class AskPasswordSettingViewController: UIViewController {
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func dismissScreen(data: Data?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    @IBAction func settingPasswordButtonTapped(_ sender: Any) {
        if passwordTextField.text != "" &&
            passwordTextField.text == passwordConfirmTextField.text {
            let realm = try! Realm()
            let allContents: Results<User> = realm.objects(User.self)
            let serverRequest: ServerRequest = ServerRequest()
            serverRequest.sendServerRequest(
                urlString: "http://tk2-235-27465.vs.sakura.ne.jp/update_account",
                params: [
                    "userid": allContents[0].userid,
                    "password": allContents[0].password,
                    "email": allContents[0].email,
                    "accountname": allContents[0].accountname,
                    "publicprivate": true,
                    "sharepassword": passwordTextField.text!
                ],
                completion: self.dismissScreen(data:))
        } else {
            explanationLabel.text = "パスワードが有効ではありません"
        }
    }

    @IBAction func notSettingPasswordButtonTapped(_ sender: Any) {
        let realm = try! Realm()
        let allContents: Results<User> = realm.objects(User.self)

        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/update_account",
            params: [
                "userid": allContents[0].userid,
                "password": allContents[0].password,
                "email": allContents[0].email,
                "accountname": allContents[0].accountname,
                "publicprivate": true,
                "sharepassword": ""
            ],
            completion: self.dismissScreen(data:))
    }
}
