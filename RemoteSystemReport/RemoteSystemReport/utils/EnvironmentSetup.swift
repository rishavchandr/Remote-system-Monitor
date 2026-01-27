//
//  EnvironmentSetup.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 27/01/26.
//

import Foundation

enum EnvironmentSetup {
    static let baseUrl: String = {
        guard let path = Bundle.main.object(
            forInfoDictionaryKey: "API_BASE_URL") as? String else{
            preconditionFailure("API_URL_NOT_FIND")
            }
        return path
    }()
}
