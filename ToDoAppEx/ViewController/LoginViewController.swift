//
//  LoginViewController.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/04/11.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var validationCheckLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!

    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = LoginViewModel(notificationCenter: notificationCenter)

    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期状態でLoginボタンは非活性でグレーにしておく
        loginButton.isEnabled = false
        loginButton.backgroundColor = .gray

        setUpBinding()
    }
    @IBAction private func login(_ sender: Any) {
        viewModel.login(email: email.text, password: password.text)
    }

    @IBAction private func tappedCreateAccountButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - private method

extension LoginViewController {
    private func setUpBinding() {
        [email, password].forEach { $0?.addTarget(
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
        notificationCenter.addObserver(
            self,
            selector: #selector(goToNext),
            name: viewModel.login,
            object: nil)
    }
}

// MARK: - ViewModel Binding

extension LoginViewController {
    @objc func textFieldEditingChanged(sender: UITextField) {
        viewModel.textFieldChange(email: email.text, password: password.text)
    }

    @objc func updateIsActivateButton(notification: Notification) {
        guard let isActive = notification.object as? Bool else { return }

        loginButton.isEnabled = isActive
        loginButton.backgroundColor = isActive ? .systemGreen : .gray
    }

    @objc func updateValidationText(notification: Notification) {
        guard let text = notification.object as? String else { return }
        DispatchQueue.main.async { [weak self] in
            self?.validationCheckLabel.text = text
        }
    }

    @objc func updateValidationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        DispatchQueue.main.async { [weak self] in
            self?.validationCheckLabel.textColor = color
        }
    }

    @objc func goToNext() {
        DispatchQueue.main.async { [weak self] in
            guard let secondViewController = self?.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else {
                return
            }
            secondViewController.modalPresentationStyle = .fullScreen
            self?.present(secondViewController, animated: false, completion: nil)
        }
    }
}
