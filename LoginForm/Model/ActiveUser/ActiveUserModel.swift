//
//  ActiveUserModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 18.03.2021.
//

import Foundation




struct ActiveUser: Codable {
    let seanceID: Int
}


struct GroupUpdate: Codable {
    let success: Int
    let name: String
    let id: Int!
}


struct MyVariables {
    static var yourVariable = 0
}


struct ShowGroupAdmin: Codable {
    let group: [ListAdmin]
}

struct ListAdmin: Codable {
    let NAME: String
    let QR: String
    let ID_GROUP: Int
    let USER_COUNT: Int
}


struct ShowGroupAdminUser: Codable {
    let user: [ListAdminUser]
}

struct ListAdminUser: Codable {
    let NN: Int
    let NAME: String
}
