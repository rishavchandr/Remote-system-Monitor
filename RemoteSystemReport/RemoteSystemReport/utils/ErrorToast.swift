//
//  ErrorToast.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct ErrorToast: View {
    let message: String
    var onDismiss: () -> Void
    var body: some View {
        HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    
                    Text(message)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
                .background(Color(.red))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.3), radius: 10)
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
    }
}

#Preview {
    ErrorToast(message: "something Wrong", onDismiss: {})
}
