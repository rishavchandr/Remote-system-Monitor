//
//  DeviceCardView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct DeviceCardView: View {
    let device: Device
    @State private var showTokenModel = false
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
                
                Button {
                    showTokenModel = true
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "key.viewfinder")
                            .font(.title2)
                        Text("Device ID")
                            .font(.system(size: 8 ,weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 60,height: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.gradient)
                    }
                    .shadow(
                        color: .blue.opacity(0.3),
                        radius: 4,x: 0, y: 2)
                }
            }
            .padding()
            
            Spacer()
            
            HStack{
                Image(systemName: "clock.badge.checkmark")
                    .font(.caption2)
                
                if let lastSeenAt = device.lastSeenAt {
                    Text("LAST SEEN: \(lastSeenAt.formatted(.dateTime.month(.wide).day().hour().minute()))")
                        .font(.system(size: 15,weight: .bold))
                        .monospaced()
                }else{
                    Text("LAST SEEN: None")
                        .font(.system(size: 10,weight: .bold))
                        .monospaced()
                }
                
                Spacer()
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
        .sheet(isPresented: $showTokenModel) {
            DeviceTokenModal(token: device.token)
                .presentationDetents([.fraction(0.4)])
        }
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
