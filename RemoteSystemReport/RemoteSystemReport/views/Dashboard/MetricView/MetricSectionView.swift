//
//  MetricSectionView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 03/02/26.
//

import SwiftUI

struct MetricSectionView<Content: View>: View {

    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            content
                .frame(height: 200)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
