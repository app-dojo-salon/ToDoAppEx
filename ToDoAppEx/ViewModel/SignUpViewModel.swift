//
//  SignUpViewModel.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2022/10/30.
//

import Foundation
import UIKit

final class SignUpViewModel {
    let changeText = Notification.Name("changeText")
    let changeColor = Notification.Name("changeColor")
    let activateButton = Notification.Name("activateButton")

    private let notificationCenter: NotificationCenter
    private let model: SignUpModelProtocol

    init(notificationCenter: NotificationCenter, model: SignUpModelProtocol = SignUpModel()) {
        self.notificationCenter = notificationCenter
        self.model = model
    }

    func textFieldChanged(email: String?, password: String?,
                          confirmPassword: String?, displayName: String?) {
        let result = model.validate(email: email, password: password, confirmPassword: confirmPassword, displayName: displayName)

        switch result {
        case .success:
            notificationCenter.post(name: changeText, object: "OK!!!")
            notificationCenter.post(name: changeColor, object: UIColor.green)
            notificationCenter.post(name: activateButton, object: true)
        case .failure(let error as SignUpModelError):
            notificationCenter.post(name: changeText, object: error.errorText)
            notificationCenter.post(name: changeColor, object: UIColor.red)
            notificationCenter.post(name: activateButton, object: false)
        case _:
            fatalError("Unexpected pattern.")
        }
    }
}

extension SignUpModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidMailAddress:
            return "有効でないメールアドレスです。"
        case .differentConfirmPassword:
            return "パスワードが一致していません。"
        case .emptyField:
            return "未入力の項目があります。"
        case .other:
            return "不明のエラーです。"
        }
    }
}
