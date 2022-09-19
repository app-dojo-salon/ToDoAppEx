//
//  User.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/07/20.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var userid = ""
    @objc dynamic var accountname = ""
    @objc dynamic var password = ""
    @objc dynamic var email = ""
    @objc dynamic var publicprivate = false
    @objc dynamic var sharepassword = ""
//    override static func primaryKey() -> String? {
//        return "userid"
//    }
}
