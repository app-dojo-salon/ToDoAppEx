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
        viewModel.createAccount(email: email.text, password: password.text, displayName: displayName.text) {
            // 成功時のみ実行され、エラーの場合にはNotificationCenter経由で通知される
            self.goToNext()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: private method

extension SignUpViewController {
    private func setUpBinding() {
        [email, password, confirmPassword, displayName].forEach { $0.addTarget(
                self,
                action: #selector(textFieldEditingChanged),
                for: .editingChanged)
        }

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

    private func goToNext() {
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
