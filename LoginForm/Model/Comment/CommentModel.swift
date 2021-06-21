//
//  CommentModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 23.03.2021.
//

import Foundation


struct UpdateComment: Codable  {
    let success: Int
}


struct ShowComment: Codable  {
    let comm: String?
}

