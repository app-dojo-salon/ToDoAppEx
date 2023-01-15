//
//  LoginModel.swift
//  ToDoAppEx
//
//  Created by 今村京平 on 2022/11/27.
//

import Foundation
import RealmSwift

enum LoginModelError: Error {
    case emptyField
    case invalidMailAddress
    case serverError
    case loginFailure
    case jsonDecord
}

protocol LoginModelProtocol {
    func validate(email: String?, password: String?) -> Result<Void>
    func login(email: String?, password: String?, completion: @escaping (Result<Void>) -> Void)
}

final class LoginModel: LoginModelProtocol {
    private let userDefaults = UserDefaults()

    func validate(email: String?, password: String?) -> Result<Void> {
        guard let email = email, let password = password else {
            return .failure(LoginModelError.emptyField)
        }

        // いずれかの入力がない場合は全て.emptyFieldを返す
        guard !email.isEmpty, !password.isEmpty else {
            return .failure(LoginModelError.emptyField)
        }

        if !email.contains("@") {
            return .failure(LoginModelError.invalidMailAddress)
        } else {
            return .success(())
        }
    }

    /// ログインをサーバーに要求
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: アカウントのパスワード
    ///   - completion: ログイン完了後に呼び出されるコールバック
    func login(email: String?, password: String?, completion: @escaping (Result<Void>) -> Void) {
        guard let email = email, let password = password else {
            // ログインボタン押下時にいずれかがnullの場合は実装の仕様違い
            fatalError()
        }

        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/login",
            params: [
                "email": email,
                "password": password
            ]) { [weak self] data in
                guard let data = data else {
                    print("server error")
                    completion(.failure(LoginModelError.serverError))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    let info = try JSONDecoder().decode(Info.self, from: data)
                    if info.isSuccessLogin {
                        guard let docs = info.docs,
                              let user = info.user else {
                            completion(.failure(LoginModelError.jsonDecord))
                            return
                        }
                        self?.userDefaults.set(true, forKey: "login")
                        self?.writeUserInfo(user: user)
                        self?.writeTodoItem(docs: docs)
                        completion(.success(()))
                    } else {
                        completion(.failure(LoginModelError.loginFailure))
                    }
                } catch {
                    print("json decord error")
                    completion(.failure(LoginModelError.jsonDecord))
                    return
                }
            }
    }

    private func writeUserInfo(user: User) {
        RealmManager.shared.writeItem(user)
    }

    private func writeTodoItem(docs: [TodoItem]) {
        let todoItems: Results<TodoItem> = RealmManager.shared.getItemInRealm(type: TodoItem.self)

        for doc in docs {
            var existFlag = false
            for todoitem in todoItems {
                if todoitem.itemid == doc.itemid && todoitem.accountname == doc.accountname {
                    existFlag = true
                    break
                }
            }

            if !existFlag {
                RealmManager.shared.writeItem(doc)
            }
        }
    }
}
