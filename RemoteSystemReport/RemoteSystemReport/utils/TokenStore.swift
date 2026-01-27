//
//  TokenStore.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 24/01/26.
//

import Foundation

final class TokenStore {
    static let shared = TokenStore()
    
    private init() {}
    
    var jwt: String?{
        get{UserDefaults.standard.string(forKey: "jwt")}
        set{UserDefaults.standard.set(newValue, forKey: "jwt")}
    }
}
