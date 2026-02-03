//
//  DockerContainerView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 03/02/26.
//

import SwiftUI

struct DockerContainerView: View {
    let container: Container
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(container.state == "running" ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                Text(container.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(container.state.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(container.state == "running" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundColor(container.state == "running" ? .green : .red)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Label(container.image, systemImage: "shippingbox")
                Text("ID: \(container.id.prefix(12))")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                ContainerLabelView(label: "CPU", value: container.cpuPercent)
                ContainerLabelView(label: "MEM", value: container.memPercent)
                
                if let ports = container.ports, !ports.isEmpty {
                    HStack(spacing: 2) {
                        Label("\(ports.count) Ports", systemImage: "network")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        
                        Text("Public: \(ports[0].publicPort)")
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                        
                        Text("Private: \(ports[0].privatePort)")
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            VStack(alignment: .leading,spacing: 2){
                Text("CreatedAt: \(container.createdAt.toReadableDate())")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Text("StartedAt: \(container.startedAt.toReadableDate())")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Text("FinishedAt: \(container.finishedAt?.toReadableDate() ?? "")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}


struct ContainerLabelView: View {
    let label: String
    let value: Double
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.system(size: 8, weight: .bold)).foregroundColor(.secondary)
            Text(String(format: "%.1f%%", value)).font(.caption.monospacedDigit()).foregroundColor(.white)
        }
    }
}


extension String {
    func toReadableDate() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: self) ?? ISO8601DateFormatter().date(from: self)
        
        guard let date = date else { return "N/A" }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}
