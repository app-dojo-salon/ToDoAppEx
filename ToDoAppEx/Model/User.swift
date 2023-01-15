//
//  User.swift
//  ToDoAppEx
//
//  Created by 泉芳樹 on 2021/07/20.
//

import Foundation
import RealmSwift

class User: Object, Decodable {
    @objc dynamic var userid = ""
    @objc dynamic var accountname = ""
    @objc dynamic var password = ""
    @objc dynamic var email = ""
    @objc dynamic var publicprivate = false
    @objc dynamic var sharepassword = ""

    enum CodingKeys: String, CodingKey {
        case userid = "_id"
        case accountname
        case password
        case email
        case publicprivate
        case sharepassword
    }
//    override static func primaryKey() -> String? {
//        return "userid"
//    }
}
