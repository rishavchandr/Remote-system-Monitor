//
//  ContentView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 23/01/26.
//

import SwiftUI

struct ContentView: View {
   @StateObject private var vm = AuthViewModel()
    
    var body: some View {
        Group {
            if vm.isAuthenticated {
                DeviceListView(authVm: vm)
            }else{
                LoginView(vm: vm)
            }
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut, value: vm.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
