//
//  Metric.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 23/01/26.
//

import Foundation


struct MetricResponse: Codable {
    let data: [Metric]
}

struct Metric: Identifiable , Codable {
    var id: String{time.description}
    let device: String?
    let cpu: CpuStats
    let memory: MemoryStats
    let disk:   DiskStats
    let extras: MetricExtra?
    let time: Date
    
    enum CodingKeys: String,CodingKey {
        case device
        case cpu
        case memory
        case disk
        case extras
        case time
    }
    
}

struct CpuStats: Codable {
    let avg: Double
    let min: Double
    let max: Double
}

struct MemoryStats: Codable {
    let last: MemoryLast
    
    struct MemoryLast : Codable {
        let used: Int
        let total: Int
    }
}

struct DiskStats : Codable {
    let last: DiskLast
    
    struct DiskLast : Codable {
        let used: Int
        let total: Double?
    }
}
