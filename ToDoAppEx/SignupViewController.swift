//
//  SignupViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.bool(forKey: "login") {
            DispatchQueue.main.async {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: false, completion: nil)
            }
        }
    }
    @IBAction func tappedLoginButton(_ sender: Any) {
        DispatchQueue.main.async {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
    @IBAction private func createAccount(_ sender: Any) {
        if password.text != "" && password.text == confirmPassword.text {
            let serverRequest: ServerRequest = ServerRequest()
            serverRequest.sendServerRequest(
                urlString: "http://tk2-235-27465.vs.sakura.ne.jp/insert_account",
                params: [
                    "accountname": self.email.text,
                    "password": self.password.text,
                    "publicprivate": false,
                    "sharepassword": ""
                ],
                completion: self.goToNext(data:))

        } else {
            email.text = "error!"
        }
    }
    func goToNext(data: Data?) {
        DispatchQueue.main.async {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
