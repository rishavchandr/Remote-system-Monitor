//
//  MetricView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 24/01/26.
//

import SwiftUI
import Charts

struct MetricView: View {
    
    @StateObject private var vm = MetricViewModel()
    @State private var selectedDate = Date()
    let deviceId: String
    
    
    var body: some View {
        NavigationView {
            ZStack{
                ScrollView{
                    VStack(spacing: 25) {
                        
                        DatePicker("Selected Date", selection: $selectedDate, displayedComponents: .date)
                            .padding()
                            .onChange(of: selectedDate) {oldDate , newDate in
                                vm.fetch(deviceId: deviceId,for: newDate)
                            }
                        
                        if(vm.isLoading && vm.metrics.isEmpty){
                            ProgressView("Loading Metrics....")
                        }else if(!vm.isLoading && vm.metrics.isEmpty) {
                            Spacer(minLength: 50)
                            VStack(alignment: .center,spacing: 6) {
                                Image(systemName: "laptopcomputer.and.arrow.down")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                    .padding()
                                    .background(Circle().stroke())
                                
                                Text("Anaylsis of this device has not be Done")
                                    .font(.title)
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .multilineTextAlignment(.center)
                            }
                        }else {
                            chartsView
                        }
                    }
                }
                .padding()
                if let error = vm.errorMessage {
                    ErrorToast(message: error) {
                        withAnimation {
                            vm.clearErrorMessage()
                        }
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                            withAnimation {
                                vm.clearErrorMessage()
                            }
                        }
                    }
                    
                }
            }
            
        }
        .navigationTitle(getHostName())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.fetch(deviceId: deviceId)
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .rotationEffect(.degrees(vm.isLoading ? 360 : 0))
                        .animation(vm.isLoading ? .linear.repeatForever(autoreverses: false) : .default, value: vm.isLoading)
                }
                
            }
        }
        .onAppear {
            vm.fetch(deviceId: deviceId, for: selectedDate)
            vm.startPolling(deviceId: deviceId)
        }
        .onDisappear {
            vm.stopPolling()
        }
        .preferredColorScheme(.dark)
        
    }
    
    func getHostName() -> String {
        if vm.metrics.count > 0 && !vm.isLoading {
            if let hostname = vm.metrics[0].extras?.agent.last.hostname {
                return hostname
            }
        }
        
        return "Host"
    }
    
    
    @ViewBuilder
    private var chartsView: some View {
        MetricSection(title: "Cpu Usage (%)") {
            Chart(vm.metrics) { metric in
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

        MetricSection(title: "Memory Capacity") {
            Chart(vm.metrics) { metric in
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

        MetricSection(title: "Disk Capacity") {
            Chart(vm.metrics) { metric in
                BarMark(
                    x: .value("Type", "Used"),
                    y: .value("Value", Double(metric.disk.last.used))
                ).foregroundStyle(.mint)
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


        MetricSection(title: "Temperature (°C)") {
            Chart(vm.metrics) { metric in
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

        MetricSection(title: "Network") {
            Chart(vm.metrics) { metric in
                
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
    }
}

#Preview {
    MetricView(deviceId: "preview-device-id")
}


struct MetricSection<Content: View>: View {
    
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

