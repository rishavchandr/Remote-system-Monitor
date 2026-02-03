//
//  DockerSectionView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 03/02/26.
//

import SwiftUI

struct DockerSectionView: View {
    @Binding var metrics: [Metric]
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let docker = metrics.last?.extras?.docker?.last {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Docker Containers")
                            .font(.title3.bold())
                        Text("\(docker.containerRunningCount) running of \(docker.containerCount) total")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
            
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(docker.containers) { container in
                            DockerContainerView(container: container)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ContentUnavailableView("No Docker Data", systemImage: "container.data.stack", description: Text("Ensure the agent has Docker permissions."))
            }
        }
    }
}

#Preview {
    DockerSectionView(metrics: .constant([]))
}
