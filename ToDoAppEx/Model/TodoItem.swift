//
//  TodoItem.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2021/03/20.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var itemid = 0
    @objc dynamic var accountname = ""
    @objc dynamic var title = ""
	@objc dynamic var image = ""
    @objc dynamic var category = ""
    @objc dynamic var startdate = ""
    @objc dynamic var enddate = ""
    override static func primaryKey() -> String? {
        return "itemid"
    }

}
