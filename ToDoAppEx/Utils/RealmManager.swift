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

    private var realm: Realm

    private init() {
        realm = try! Realm()
    }

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

    /// ToDoItemの項目を修正する
    ///
    /// 独自の書き込みが必要になるため専用で置く
    func changeStatusToDoItem<T>(type: T.Type, index: Int) where T: TodoItem {
        let list = getItemInRealm(type: type.self)

        do {
            try realm.write {
                list[index].status = !list[index].status
            }
        } catch {
            print("ステータスの変更に失敗しました")
        }
    }
}
