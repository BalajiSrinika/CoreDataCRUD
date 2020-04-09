//
//  Person.swift
//  CoreDataCRUD
//
//  Created by Sabari on 07/04/20.
//  Copyright © 2020 Sabari. All rights reserved.
//

import Foundation

// MARK: - UserData
struct UserData: Codable {
    let userList: [UserList]?

    enum CodingKeys: String, CodingKey {
        case userList = "user_list"
    }
}

// MARK: - UserList
struct UserList: Codable {
    let name: String?
    let gender: String?
    let age: Int?
    let email: String?
    let phone: String?
    let address: String?
    let company: String?
    let id: String?
    let isActive: Bool?
}
