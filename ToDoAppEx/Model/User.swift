//
//  User.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/07/20.
//

import Foundation
import RealmSwift

class User: Object {
//    @objc dynamic var userid = ""
    @objc dynamic var accountname = ""
    @objc dynamic var password = ""
//    override static func primaryKey() -> String? {
//        return "userid"
//    }
}
