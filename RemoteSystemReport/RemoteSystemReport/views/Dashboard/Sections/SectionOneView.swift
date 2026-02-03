//
//  SectionOneView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 03/02/26.
//

import SwiftUI
import Charts

//CPU & NETWORK & TEMPERATURE sections
struct SectionOneView: View {
    @Binding var metrics: [Metric]
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer()
                VStack(spacing: 15) {
                    MetricSectionView(title: "Cpu Usage") {
                        Chart(metrics) { metric in
                            AreaMark(
                                x: .value("Time", metric.time),
                                yStart: .value("Min", metric.cpu.min),
                                yEnd: .value("Max", metric.cpu.max)
                            )
                            .foregroundStyle(.blue.opacity(0.1))
                            
                            LineMark(
                                x: .value("Time", metric.time),
                                y: .value("Avg", metric.cpu.avg)
                            )
                            .foregroundStyle(.blue)
                            .interpolationMethod(.catmullRom)
                        }
                    }
        
                    MetricSectionView(title: "Network Analysis") {
                        Chart(metrics) { metric in
                            
                            if let last = metric.extras?.network?.last {
                                LineMark(
                                    x: .value("Time", metric.time),
                                    y: .value("Received", max(1,last.rxBytes))
                                )
                                .foregroundStyle(by: .value("Type", "Received"))
                                
                                LineMark(
                                    x: .value("Time", metric.time),
                                    y: .value("Sent", max(1,last.txBytes))
                                )
                                .foregroundStyle(by: .value("Type", "Sent"))
                            }
                            
                        }
                        .chartForegroundStyleScale([
                            "Received": .green,
                            "Sent": .red
                        ])
                        .chartYScale(type: .log)
                        .chartYAxis {
                            AxisMarks(values: .automatic) { value in
                                AxisGridLine()
                                AxisTick()
                                if let doubleValue = value.as(Double.self) {
                                    let intValue = Int64(doubleValue)
                                    AxisValueLabel {
                                        Text(intValue, format: .byteCount(style: .file))
                                    }
                                }
                            }
                        }
                    }
                    
                    MetricSectionView(title: "Temperature (°C)") {
                        Chart(metrics) { metric in
                            if let last = metric.extras?.temperature?.last {
                                
                                LineMark(
                                    x: .value("Time", metric.time),
                                    y: .value("Temp", last.chipset)
                                )
                                .foregroundStyle(.purple.opacity(0.3))
                                
                                PointMark(
                                    x: .value("Time", metric.time),
                                    y: .value("Temp", last.chipset)
                                )
                                .foregroundStyle(.purple)
                                .symbolSize(30)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SectionOneView(metrics: .constant([]))
}
