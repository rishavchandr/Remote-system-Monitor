//
//  DeviceRegistrationView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct DeviceRegistrationView: View {
    
    @ObservedObject var vm: DeviceViewModel
    @Environment(\.dismiss) var dismiss
    @State private var deviceName = ""
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                VStack(spacing: 10){
                    RegistrationForm
                    Text("After Registration See the device id from Device list and Paste it to agent")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.blue)
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .onChange(of: vm.isRegisteringCompletion) { oldValue, newValue in
            if newValue {
                dismiss()
                vm.isRegisteringCompletion = false
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private var RegistrationForm: some View {
        Form {
            Section(footer: Text("Give your device a unique name")) {
                TextField("Device Name",text: $deviceName)
            }
            
            Button {
                vm.registerDevice(name: deviceName)
            } label: {
                if vm.isRegistering {
                    ProgressView()
                }else{
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
            }
            .disabled(vm.isRegistering || deviceName.isEmpty)
        }
    }
}

#Preview {
    DeviceRegistrationView(vm: DeviceViewModel())
}


