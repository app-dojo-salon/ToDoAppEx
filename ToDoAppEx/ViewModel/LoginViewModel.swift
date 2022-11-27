//
//  LoginViewModel.swift
//  ToDoAppEx
//
//  Created by 今村京平 on 2022/11/27.
//

import Foundation
import UIKit

final class LoginViewModel {
    let changeText = Notification.Name("changeLoginText")
    let changeColor = Notification.Name("changeLoginColor")
    let activateButton = Notification.Name("activateLoginButton")
    let login = Notification.Name("login")

    private let notificationCenter: NotificationCenter
    private let model: LoginModelProtocol

    init(notificationCenter: NotificationCenter, model: LoginModelProtocol = LoginModel()) {
        self.notificationCenter = notificationCenter
        self.model = model
    }

    func textFieldChange(email: String?, password: String?) {
        let result = model.validate(email: email, password: password)

        switch result {
        case .success:
            notificationCenter.post(name: changeText, object: "OK!!!")
            notificationCenter.post(name: changeColor, object: UIColor.green)
            notificationCenter.post(name: activateButton, object: true)
        case .failure(let error as LoginModelError):
            notificationCenter.post(name: changeText, object: error.errorText)
            notificationCenter.post(name: changeColor, object: UIColor.red)
            notificationCenter.post(name: activateButton, object: false)
        case .failure(_):
            fatalError("Unexpected pattern.")
        }
    }

    func login(email: String?, password: String?) {
        model.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.notificationCenter.post(name: self.login, object: nil)
            case .failure(let error as LoginModelError):
                self.notificationCenter.post(name: self.changeText, object: error.errorText)
                self.notificationCenter.post(name: self.changeColor, object: UIColor.red)
            case .failure(_):
                fatalError("Unexpected pattern.")
            }
        }
    }
}

extension LoginModelError {
    fileprivate var errorText: String {
        switch self {
        case .emptyField:
            return "未入力の項目があります。"
        case .invalidMailAddress:
            return "有効でないメールアドレスです。"
        case .serverError:
            return "通信でエラーが発生しました。通信環境をお確かめください。"
        case .loginFailure:
            return "ログインに失敗しました。メールアドレスとパスワードが正しいかお確かめください。"
        case .jsonDecord:
            return "処置中に問題が発生しました。"
        }
    }
}
