//
//  BatteryStatusRow.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 03/02/26.
//

import SwiftUI

struct BatteryStatusRow: View {
    let cycleCount: Int
    let isCharging: Bool
    let percent: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "arrow.2.circlepath")
                Text(" CycleCount: \(cycleCount)")
            }
            Spacer()
            HStack(spacing: 10 ) {
                Image(systemName: isCharging ? "bolt.fill" : "powerplug")
                Text(isCharging ? "Charging" : "Plug in")
            }
            .foregroundColor(isCharging ? .green : .yellow)
            
            Spacer()
            Text("\(percent)%")
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)
        }
        .font(.subheadline)
        .padding(.horizontal,5)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
        .frame(height: 40)
    }
}
