//
//  MetricView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 24/01/26.
//

import SwiftUI

struct MetricView: View {
    
    @StateObject private var vm = MetricViewModel()
    @State private var selectedDate = Date()
    let deviceId: String
    @State private var showTokenModel = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.black.ignoresSafeArea()
                ScrollView{
                    VStack(spacing: 25) {
                        
                        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            .padding()
                            .onChange(of: selectedDate) {oldDate , newDate in
                                vm.fetch(deviceId: deviceId,for: newDate)
                            }
                        
                        if(vm.isLoading && vm.metrics.isEmpty){
                            ProgressView("Loading Metrics....")
                        }else {
                            systemInfoSection
                            
                            
                        }
                    }
                    Spacer(minLength: 120)
                    VStack(alignment: .center,spacing: 5){
                        Text("paste token from here to agent")
                            .font(.caption2)
                            .bold()
                        
                        Button {
                            showTokenModel = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("Device token")
                                    .font(.system(size: 8 ,weight: .bold))
                                Image(systemName: "key.viewfinder")
                                    .font(.title2)
                            }
                            .foregroundColor(.white)
                            .frame(width: 80,height: 30)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.gradient)
                            }
                            .shadow(
                                color: .blue.opacity(0.3),
                                radius: 4,x: 0, y: 2)
                        }
                    }
                }
                
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
        .navigationTitle(getPlatformName())
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
        .sheet(isPresented: $showTokenModel) {
            DeviceTokenModal(token: "ndeindnininisnmism")
                .presentationDetents([.fraction(0.4)])
        }
        
        
    }
    
    func getPlatformName() -> String {
        if vm.metrics.count > 0 && !vm.isLoading {
            if let platformName = vm.metrics[0].extras?.agent.last.platform {
                return platformName
            }
        }
        
        return "UNKNOWN"
    }
    
    
    @ViewBuilder
    private var systemInfoSection: some View {
        let count = vm.metrics.count
        VStack(spacing: 16) {
           
            if(count > 0){
                let battery = vm.metrics[count-1].battery.last
                let hostName = vm.metrics[0].extras?.agent.last.hostname
                VStack(alignment: .leading ,spacing: 15){
                        
                    BatteryStatusRow(
                        cycleCount: battery.cycleCount,
                        isCharging: battery.isCharging,
                        percent: battery.percent)
                    
                    Text("HostName: \(hostName ?? "UnkownHost")")
                        .font(.title3.bold())
                    
                }
                .padding(.bottom,10)
            }
            //Cpu - Netwrok - Temperature
            NavigationLink(destination: SectionOneView(metrics: $vm.metrics)){
                SysytemInfoView(
                    image: "core",
                    name: "Core",
                    description: "Real-time processor load and core frequency.Active upload/download speeds and data throughput.Thermal readings for internal hardware"
                )
            }
            .disabled(count < 1)
            .opacity((count < 1) ? 0.5 : 1.0)
            
            // Disk & memory
            NavigationLink(destination: SectionTwoView(metrics: $vm.metrics)){
                SysytemInfoView(
                    image: "memory",
                    name: "Storage",
                    description: "RAM allocation and swap file performance.Drive health, read/write speeds, and available space"
                )
            }
            .disabled(count < 1)
            .opacity((count < 1) ? 0.5 : 1.0)
            
            //Docker section info
            NavigationLink(destination: DockerSectionView(metrics: $vm.metrics)){
                SysytemInfoView(
                    image: "docker",
                    name: "Docker",
                    description: "Monitor active container status, image resources, and volume health. Keep track of your microservices and deployment uptime in real-time"
                )
            }
            .disabled(count < 1)
            .opacity((count < 1) ? 0.5 : 1.0)
        }
        .padding(.horizontal)
            
    }
}

#Preview {
    MetricView(deviceId: "preview-device-id")
}
