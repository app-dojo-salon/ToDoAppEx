//
//  TodoItem.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2021/03/20.
//

import Foundation
import RealmSwift

class TodoItem: Object {
	@objc dynamic var title = ""
	@objc dynamic var image = ""
    @objc dynamic var category = ""
    @objc dynamic var startDate = ""
    @objc dynamic var endDate = ""
}
