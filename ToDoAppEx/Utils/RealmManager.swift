//
//  RealmManager.swift
//  ToDoAppEx
//
//  Created by Naoyuki Kan on 2022/06/16.
//

import Foundation
import RealmSwift


/// Realmを管理するManager
final class RealmManager {
    // シングルトンとして使用
    public static let shared = RealmManager()

    private var realm: Realm {
        try! Realm()
    }

    private init() {}

    /// Realmからデータを取得する
    ///
    /// Objectに準拠した型を指定してRealmからデータをReselt<Object>として取得する
    func getItemInRealm<T>(type: T.Type) -> Results<T> where T: Object {
        return realm.objects(type.self)
    }

    /// Realmにデータを追加する
    ///
    /// 与えられたObjectのItemを追加する
    func writeItem<T>(_ value: T) where T: Object {
        do {
            try realm.write {
                realm.add(value)
                print("新しいリスト追加")
            }
        } catch {
            print("新しいタスクの書き込みに失敗")
        }
    }

    /// Realmのデータを削除する
    ///
    /// 与えられたObjectのitemを削除する
    func deleteItem(item: ObjectBase) {
        do {
            try realm.write {
                print("\(item)を削除")
                realm.delete(item)
            }
        } catch {
            print("削除に失敗")
        }
    }

    /// Realmにあるデータを全て削除する
    func deleteAllItem(){
        do {
            try realm.write {
                print("すべてのRealmのデータを削除")
                realm.deleteAll()
            }
        } catch {
            print("すべてのRealmのデータ削除に失敗")
        }
    }

    private func searchIndex(uuid: String, list: Results<TodoItem>) -> Int? {
        var index = 0
        for item in list {
            if item.itemid == uuid {
                return index
            }
            index = index + 1
        }
        return nil
    }

    /// ToDoItemのステータスを修正する
    ///
    /// 独自の書き込みが必要になるため専用で置く
    func changeStatusToDoItem<T>(type: T.Type, uuid: String) where T: TodoItem {
        let list = getItemInRealm(type: type.self)
        guard let index = searchIndex(uuid: uuid, list: list as! Results<TodoItem>) else {
            print("ステータスの変更に失敗しました")
            return
        }

        do {
            try realm.write {
                list[index].status = !list[index].status
            }
        } catch {
            print("ステータスの変更に失敗しました")
        }
    }

    /// ToDoItemの内容を編集する
    func editToDoItem(item: ItemData, index: Int) {
        let list = getItemInRealm(type: TodoItem.self)

        do {
            try realm.write {
                list[index].title = item.title
                list[index].category = item.category
                list[index].startdate = item.startDate
                list[index].enddate = item.endDate
            }
        } catch {
            print("アイテムの編集に失敗しました")
        }
    }
}
