//
//  Device.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 23/01/26.
//

import Foundation

struct DeviceResponse: Codable {
    let data: Device
}

struct Device: Codable, Identifiable {
    let id: String
    let name: String
    let token: String
    let lastSeenAt: Date?
    let user: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String,CodingKey {
        case id = "_id"
        case name
        case token
        case user
        case lastSeenAt
        case createdAt
        case updatedAt
    }
}
