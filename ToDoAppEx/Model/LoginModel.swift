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
                    // dataをJSONパースし、変数"getJson"に格納
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let isSuccessLogin : Bool = (json as? NSDictionary)?["login"] as? Bool else {
                        completion(.failure(LoginModelError.jsonDecord))
                        return
                    }
                    if isSuccessLogin {
                        guard let docs = (json as? NSDictionary)?["docs"] as? NSArray,
                              let account_scope = (json as? NSDictionary)?["account"] as? NSDictionary else {
                            completion(.failure(LoginModelError.jsonDecord))
                            return
                        }
                        self?.userDefaults.set(true, forKey: "login")
                        self?.writeUserInfo(account_scope: account_scope)
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

    private func writeUserInfo(account_scope: NSDictionary) {
        let user = User()
        user.userid = account_scope["_id"] as! String
        user.accountname = account_scope["accountname"] as! String
        user.password = account_scope["password"] as! String
        user.email = account_scope["email"] as! String

        RealmManager.shared.writeItem(user)
    }

    private func writeTodoItem(docs: NSArray) {
        let todoItems: Results<TodoItem> = RealmManager.shared.getItemInRealm(type: TodoItem.self)

        for doc in docs {
            guard let doc = doc as? NSDictionary else { return }
            let item = TodoItem()
            item.itemid = doc["itemid"] as! String
            print(item.itemid)
            item.accountname = doc["accountname"] as! String
            item.userid = doc["userid"] as! String

            var existFlag = false
            for todoitem in todoItems {
                if todoitem.itemid == item.itemid && todoitem.accountname == item.accountname {
                    existFlag = true
                    break
                }
            }

            if !existFlag {
                item.category = doc["category"] as! String
                item.image = doc["image"] as! String
                item.title = doc["title"] as! String
                item.startdate = doc["startdate"] as! String
                item.enddate = doc["enddate"] as! String
                RealmManager.shared.writeItem(item)
            }
        }
    }
}
