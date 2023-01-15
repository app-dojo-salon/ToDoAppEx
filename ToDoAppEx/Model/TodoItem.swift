//
//  TodoItem.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2021/03/20.
//

import Foundation
import RealmSwift

class TodoItem: Object, Decodable {
    @objc dynamic var itemid = ""
    @objc dynamic var accountname = ""
    @objc dynamic var userid = ""
    @objc dynamic var title = ""
	@objc dynamic var image = ""
    @objc dynamic var category = ""
    @objc dynamic var startdate = ""
    @objc dynamic var enddate = ""
    @objc dynamic var status = false
    override static func primaryKey() -> String? {
        return "itemid"
    }

    enum CogingKeys: String, CodingKey {
        case itemid
        case accountname
        case userid
        case title
        case image
        case category
        case startdate
        case enddate
        case status
    }
}
