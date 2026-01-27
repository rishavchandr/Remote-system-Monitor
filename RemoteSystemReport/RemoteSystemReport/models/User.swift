//
//  User.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 23/01/26.
//

import Foundation


struct User: Codable,Identifiable {
    let id: String
    let email: String
    let token: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String , CodingKey {
        case id = "_id"
        case email
        case token
        case createdAt
        case updatedAt
    }
}

struct UserResponse: Codable {
    let data: User
}

struct logOutResponse: Codable {
    
}
