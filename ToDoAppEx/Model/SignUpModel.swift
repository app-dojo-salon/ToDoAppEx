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
    case serverError
    case jsonDecord
    case other
}

protocol SignUpModelProtocol {
    func validate(email: String?, password: String?,
                  confirmPassword: String?, displayName: String?) -> Result<Void>
    func createAccount(email: String?, password: String?, displayName: String?, completion: @escaping (Result<Void>) -> Void)
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

    /// アカウント作成をサーバーに要求
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: アカウントのパスワード
    ///   - displayName: アカウント名
    ///   - completion: アカウント作成完了後に呼び出されるコールバック
    ///
    ///  protocolではデフォルト引数が指定できないため再度呼び出して、共有機能のデフォルトでの値を指定している
    func createAccount(email: String?, password: String?, displayName: String?, completion: @escaping (Result<Void>) -> Void) {
        createAccount(email: email, password: password, displayName: displayName, isPublic: false, sharePassword: "", completion: completion)
    }

    private func createAccount(email: String?, password: String?, displayName: String?, isPublic: Bool, sharePassword: String, completion: @escaping (Result<Void>) -> Void) {
        guard let email = email, let password = password,
              let displayName = displayName else {
            // アカウント作成ボタン押下時にいずれかがnullの場合には実装の仕様違い
            fatalError()
        }

        let serverRequest: ServerRequest = ServerRequest()
        serverRequest.sendServerRequest(
            urlString: "http://tk2-235-27465.vs.sakura.ne.jp/insert_account",
            params: [
                "accountname": displayName,
                "password": password,
                "email": email,
                "publicprivate": isPublic,
                "sharepassword": sharePassword
            ]) { data in
                guard let data = data else {
                    print("server error")
                    completion(.failure(SignUpModelError.serverError))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let doc = json as? NSDictionary else {
                        completion(.failure(SignUpModelError.jsonDecord))
                        return
                    }
                    self.writeUserInfo(doc: doc)
                    completion(.success(()))
                } catch {
                    print("json decord error")
                    completion(.failure(SignUpModelError.jsonDecord))
                    return
                }
            }
    }

    func writeUserInfo(doc: NSDictionary) {
        let user = User()
        user.userid = doc["_id"] as! String
        user.accountname = doc["accountname"] as! String
        user.password = doc["password"] as! String
        user.email = doc["email"] as! String
        user.publicprivate = doc["publicprivate"] as! Bool
        user.sharepassword = doc["sharepassword"] as! String

        RealmManager.shared.writeItem(user)
    }
}
