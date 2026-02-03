//
//  DeviceCardView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct DeviceCardView: View {
    let device: Device
    var body: some View {
        VStack(alignment: .leading , spacing: 0, content: {
            
            
            HStack(alignment: .center){
                VStack(alignment: .leading, spacing: 6) {
                    Text("Device name")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(.blue)
                        .kerning(1)
                    
                    Text(device.name)
                        .font(.system(.title3 ,design: .monospaced))
                        .fontWeight(.bold)
                        .lineLimit(1)
                 }
                
                Spacer()
            }
            .padding()
            Spacer()
            
            HStack{
                Image(systemName: "clock.badge.checkmark")
                    .font(.caption2)
                
                if let lastSeenAt = device.lastSeenAt {
                    Text("LAST SEEN: \(lastSeenAt.formatted(.dateTime.month(.wide).day().hour().minute()))")
                        .font(.system(size: 10,weight: .bold))
                        .monospaced()
                }else{
                    Text("LAST SEEN: None")
                        .font(.system(size: 10,weight: .bold))
                        .monospaced()
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(.horizontal)
            .padding(.vertical,10)
            .background(Color.primary.opacity(0.05))
            
        })
        .frame(height: 160)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1),lineWidth: 1)
        }
        .padding(.horizontal)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    DeviceCardView(device:
                    Device(
                    id: "79u94u239u298u39u2",
                    name: "Hello",
                    token: "8eu983u98u9u982u98ue93ue83u983",
                    lastSeenAt: Date(),
                    user: "32e3289e893h9hdwdnwiund",
                    createdAt: Date(),
                    updatedAt: Date()))
}
