//
//  DeviceViewModel.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import Foundation
import Combine

@MainActor
final class DeviceViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var errorMessage: String?
    @Published var newDevice: Device?
    @Published var isRegisteringCompletion = false
    
    @Published var isLoading = false
    
    func fetchDevices(){
        isLoading = true
        
        ApiClient.shared.request(path: "/devices") { (result: Result<[Device],Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.devices = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    @Published var isRegistering = false
    func registerDevice(name: String){
        isRegistering = true
        
        let body: [String: Any] = ["name" : name]
        
        ApiClient.shared.request(
            path: "/registerDevice",
            method: "POST" ,
            body: body) { (result: Result<DeviceResponse,Error>) in
                DispatchQueue.main.async {
                    self.isRegistering = false
                    switch result {
                    case .success(let response):
                        self.newDevice = response.data
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                            self.isRegisteringCompletion = true
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
        }
    }
    
    func clearErrorMessage(){
        self.errorMessage = nil
    }
}
