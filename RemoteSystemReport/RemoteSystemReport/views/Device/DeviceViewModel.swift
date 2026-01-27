//
//  DeviceViewModel.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class DeviceViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var errorMessage: String?
    @Published var newDevice: Device?
    @Published var isRegisteringCompletion = false
    @Published var errorMessageForRegistration: String?
    
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
                        self.errorMessageForRegistration = error.localizedDescription
                    }
                }
        }
    }
    
    func deleteDevices(at offsets: IndexSet){
        guard let index = offsets.first else {return}
        let deviceId = devices[index].id
        print("Attempting to delete device with ID: \(deviceId)")
        ApiClient.shared.request(
            path: "/remove/device/\(deviceId)",
            method: "DELETE") { (result: Result<DefaultResponse,Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.devices.remove(atOffsets: offsets)
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
