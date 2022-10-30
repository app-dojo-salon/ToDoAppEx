//
//  SignUpViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit
import RealmSwift

class SignUpViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var validationCheckLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!

    private let userDefaults = UserDefaults()
    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = SignUpViewModel(
        notificationCenter: notificationCenter)

    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.bool(forKey: "login") {
            DispatchQueue.main.async {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: false, completion: nil)
            }
        }

        // 初期状態でCreate Accountボタンは非活性でグレーにしておく
        createAccountButton.isEnabled = false
        createAccountButton.backgroundColor = .gray

        setUpBinding()
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
                    "accountname": self.displayName.text ?? "",
                    "password": self.password.text ?? "",
                    "email": self.email.text ?? "",
                    "publicprivate": false,
                    "sharepassword": ""
                ],
                completion: self.goToNext(data:))

        } else {
            email.text = "error!"
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: private method

extension SignUpViewController {
    private func setUpBinding() {
        email.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)
        password.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)
        confirmPassword.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)
        displayName.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)
        notificationCenter.addObserver(
            self,
            selector: #selector(updateValidationText),
            name: viewModel.changeText,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(updateIsActivateButton),
            name: viewModel.activateButton,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(updateValidationColor),
            name: viewModel.changeColor,
            object: nil)
    }

    private func goToNext(data: Data?) {

        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let doc = json as! NSDictionary
            let user = User()
            user.userid = doc["_id"] as! String
            user.accountname = doc["accountname"] as! String
            user.password = doc["password"] as! String
            user.email = doc["email"] as! String
            user.publicprivate = doc["publicprivate"] as! Bool
            user.sharepassword = doc["sharepassword"] as! String
            RealmManager.shared.writeItem(user)
        } catch {
            print("signup error")
            return
        }
        DispatchQueue.main.async {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }

}

// MARK: ViewModel Binding

extension SignUpViewController {
    @objc func textFieldEditingChanged(sender: UITextField) {
        viewModel.textFieldChanged(email: email.text, password: password.text, confirmPassword: confirmPassword.text, displayName: displayName.text)
    }

    @objc func updateIsActivateButton(notification: Notification) {
        guard let isActive = notification.object as? Bool else { return }

        createAccountButton.isEnabled = isActive
        createAccountButton.backgroundColor = isActive ? .systemGreen : .gray
    }

    @objc func updateValidationText(notification: Notification) {
        guard let text = notification.object as? String else { return }
        validationCheckLabel.text = text
    }

    @objc func updateValidationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        validationCheckLabel.textColor = color
    }
}
