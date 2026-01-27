//
//  MetricExtra.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 23/01/26.
//

import Foundation

struct MetricExtra: Codable {
    let network: NetworkStats?
    let temperature: TemperatureStats?
    let agent: AgentStats
}

struct NetworkStats: Codable {
    let last: NetworkLast
    
    struct NetworkLast: Codable {
        let iface, operstate: String
        let rxBytes, rxDropped, rxErrors, txBytes: Int
        let txDropped, txErrors: Int
        let rxSEC, txSEC: Double?
        let ms: Int
        
        enum CodingKeys: String, CodingKey {
            case iface, operstate
            case rxBytes = "rx_bytes"
            case rxDropped = "rx_dropped"
            case rxErrors = "rx_errors"
            case txBytes = "tx_bytes"
            case txDropped = "tx_dropped"
            case txErrors = "tx_errors"
            case rxSEC = "rx_sec"
            case txSEC = "tx_sec"
            case ms
        }
    }
}

struct TemperatureStats: Codable{
    let last: TemperatureLast
    
    struct TemperatureLast: Codable {
        let main: Double
        let cores: [Double]
        let max: Double
        let socket: [Double]?
        let chipset: Double
    }
}

struct AgentStats: Codable{
    let last: AgentLast
    
    struct AgentLast: Codable {
        let version, hostname, platform: String
    }
}
