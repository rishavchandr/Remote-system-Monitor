//
//  SectionTwoView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 03/02/26.
//

import SwiftUI
import Charts

//DISK & MEMORY sections
struct SectionTwoView: View {
    @Binding var metrics: [Metric]
    var body: some View {
        NavigationStack {
            ScrollView{
                Spacer()
                VStack(spacing: 20) {
                    
                    MetricSectionView(title: "Memory Capacity") {
                        Chart(metrics) { metric in
                            BarMark(
                                x: .value("Type", "Used"),
                                y: .value("Value", Double(metric.memory.last.used))
                            ).foregroundStyle(.orange)
                            
                            BarMark(
                                x: .value("Type", "Total"),
                                y: .value("Value", Double(metric.memory.last.total))
                            ).foregroundStyle(.gray.opacity(0.3))
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic) { value in
                                AxisGridLine()
                                AxisTick()
                                if let doubleValue = value.as(Double.self) {
                                    let intValue = Int64(doubleValue * 1024 * 1024)
                                    AxisValueLabel {
                                        Text(intValue, format: .byteCount(style: .binary))
                                    }
                                }
                            }
                        }
                    }

                    MetricSectionView(title: "Disk Capacity") {
                        Chart(metrics) { metric in
                            BarMark(
                                x: .value("Type", "Used"),
                                y: .value("Value", Double(metric.disk.last.used))
                            ).foregroundStyle(.orange)
                            
                            BarMark(
                                x: .value("Type", "Total"),
                                y: .value("Value", Double(metric.disk.last.total))
                            ).foregroundStyle(.gray.opacity(0.3))
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic) { value in
                                AxisGridLine()
                                AxisTick()
                                if let doubleValue = value.as(Double.self) {
                                    let intValue = Int64(doubleValue * 1024 * 1024)
                                    AxisValueLabel {
                                        Text(intValue, format: .byteCount(style: .binary))
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }.padding(.horizontal)
            
        }
    }
}

#Preview {
    SectionTwoView(metrics: .constant([]))
}
