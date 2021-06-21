//
//  K.swift
//  LoginForm
//
//  Created by shiryaev-da on 23.01.2021.
//

import Foundation

struct K {
    static let  wayHttps = "https://shi-ku.ru:8443/ords/interval/"
    
    static let fontMain  = "MPLUS1p-"
    static let fontRegular = fontMain + "Regular"
    static let fontLight = fontMain + "Light"
    static let fontSemiBold = fontMain + "Bold"
    static let fontBold = fontMain + "Bold"
    static let fontThin = fontMain + "Thin"
    
    
    //Основные переменные
    static var userName: String!
    static var userLogin: String!
    static var groupName: String!
    static var teamLeader: Int!
    static var numberOfRows: [IndexPath] = []
    static var rederectUrl: String!
    static var userPass: String!
    static var mailCheck: Bool = false
    
    
    
    // Профиль
    static var idGroupProfile: Int!
    static var numberOfRowsProfilGroup: [IndexPath] = []
    static var urlTabBar: String!
    
    
    // Шаги
    
    static var activeIDStep: Int!
    static var activeIDTopic: Int!
    
    //
    
}


