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
                DeviceListView(onLogout: {vm.logOutUser()})
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


//Instruction before running
/*
 -> go project
 -> go to build settings of both target and project
 -> go to user-defined values
 -> change your domain for the local environment and prod environment
 */
