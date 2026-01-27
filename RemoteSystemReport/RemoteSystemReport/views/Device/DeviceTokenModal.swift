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
    @State private var copied = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1a1a1a").ignoresSafeArea()
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "cpu.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue.gradient)
                        
                        Text("Registration Successful")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Copy this token to your Agent's config file to start monitoring.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DEVICE TOKEN")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.blue.opacity(0.8))
                            .tracking(2)
                        
                        HStack {
                            Text(token)
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer()
                            
                            Button {
                                UIPasteboard.general.string = token
                                withAnimation(.spring()) {
                                    copied = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { copied = false }
                                }
                            } label: {
                                Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                    .foregroundColor(copied ? .green : .blue)
                                    .contentTransition(.symbolEffect(.replace))
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(LinearGradient(colors: [.blue.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
