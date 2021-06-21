//
//  registerModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 27.10.2020.
//

import Foundation


struct ResponceData: Codable {
    let statusUser: Int
}
struct ResponceModel {
    let statusUser: Int
    
    var statusUserStr: String {
        switch statusUser {
        case 1:
            return "Пользователь с таким Логином или E-mail уже существует"
        case 0:
            return "Пользователь зарегистрирован! Вам отправлено письмо на почту для ее подтверждения. Функции приложения будут доступны после верификации почтового ящика который вы указали."
        case 2:
            return "Не все поля заполнены"
        default:
            return "-"
    }
    }
}


struct ListGroup: Codable {
    let group: [List]
}

struct List: Codable {
    let name: String
    let group_id: Int
}



