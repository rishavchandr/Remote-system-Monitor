//
//  DeviceTokenModal.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct DeviceTokenModal: View {
    let token: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            
            VStack{
                
                VStack(alignment: .leading , spacing: 12){
                    Text("Device Token")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text(token)
                            .font(.system(.body, design: .monospaced))
                            .font(.system(size: 20))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Button {
                            UIPasteboard.general.string = token
                        } label: {
                            Image(systemName: "doc.on.doc.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green , lineWidth: 1)
                )
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") { dismiss() }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    DeviceTokenModal(token: "")
}
