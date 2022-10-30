//
//  SignUpModel.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2022/10/29.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum SignUpModelError: Error {
    case invalidMailAddress
    case differentConfirmPassword
    case emptyField
    case other
}

protocol SignUpModelProtocol {
    func validate(email: String?, password: String?,
                  confirmPassword: String?, displayName: String?) -> Result<Void>
}

final class SignUpModel: SignUpModelProtocol {
    func validate(email: String?, password: String?,
                  confirmPassword: String?, displayName: String?) -> Result<Void> {
        guard let email = email, let password = password,
              let confirmPassword = confirmPassword, let displayName = displayName else {
                  return .failure(SignUpModelError.emptyField)
              }

        // いずれかの入力がない場合は全て.emptyFieldを返す
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !displayName.isEmpty else {
            return .failure(SignUpModelError.emptyField)
        }

        if confirmPassword != password {
            return .failure(SignUpModelError.differentConfirmPassword)
        } else if !email.contains("@") {
            return .failure(SignUpModelError.invalidMailAddress)
        } else {
            return .success(())
        }
    }
}
