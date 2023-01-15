//
//  Info.swift
//  ToDoAppEx
//
//  Created by 今村京平 on 2022/12/10.
//

import Foundation

struct Info: Decodable {
    let isSuccessLogin: Bool
    let docs: [TodoItem]?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case isSuccessLogin = "login"
        case docs = "docs"
        case user = "account"
    }
}
