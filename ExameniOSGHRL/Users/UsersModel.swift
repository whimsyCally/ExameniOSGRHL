//
//  UsersModel.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 29/05/22.
//

import Foundation
// MARK: - UsersModel
struct UserModel: Codable, Identifiable{
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

typealias UsersModel = [UserModel]
