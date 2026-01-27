//
//  DeviceListView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct DeviceListView: View {
    
    @State private var showAddDevice = false
    @State private var showAlertofLimitReached = false
    @StateObject private var vm = DeviceViewModel()
    @ObservedObject var authVm: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                
                if(vm.devices.isEmpty){
                    VStack(alignment: .center,spacing: 6) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .padding()
                            .background(Circle().stroke())
                        
                        Text("No Devices are Listed")
                            .font(.largeTitle)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }else{
                 
                    ScrollView{
                        VStack(spacing: 10) {
                            ForEach(vm.devices) { device in
                                NavigationLink(destination: MetricView(deviceId: device.id)) {
                                    DeviceCardView(device: device)
                                }
                            }
                        }
                    }
                    .refreshable {
                        vm.fetchDevices()
                    }
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            if vm.devices.count < 3{
                                showAddDevice = true
                            }else{
                                showAlertofLimitReached = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 4)
                        }
                    }
                    .padding(30)
                }
                
                if let error = vm.errorMessage {
                    ErrorToast(message: error) {
                        withAnimation {
                            vm.clearErrorMessage()
                        }
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                            withAnimation {
                                vm.clearErrorMessage()
                            }
                        }
                    }
                }
            }
            .onAppear{
                vm.fetchDevices()
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showAddDevice) {
                DeviceRegistrationView(vm: vm)
                    .presentationDetents([.medium])
                    .presentationCornerRadius(20)
            }
            .alert("Device Limit",
                   isPresented: $showAlertofLimitReached) {
                Button("OK", role: .cancel) {}
            }message: {
                Text("Not more than Three Devices")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authVm.logOutUser()
                    } label: {
                        HStack(spacing: 4) {
                            Text("Logout")
                                .font(.system(size: 14, weight: .bold))
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundStyle(Color(.white))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.blue).opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }
}

#Preview {
    DeviceListView(authVm: AuthViewModel())
        
}



