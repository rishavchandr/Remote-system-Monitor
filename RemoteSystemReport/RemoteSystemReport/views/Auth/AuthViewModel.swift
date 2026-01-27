//
//  AuthViewModel.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var user: User?
    
    
    init() {
       checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        let savedToken = UserDefaults.standard.string(forKey: "jwt")
        if  savedToken != nil {
            self.isAuthenticated = true
        }else{
            self.isAuthenticated = false
        }
        
        self.email = ""
        self.password = ""
    }
    
    func login() {
        self.isLoading = true
        
        let body: [String: Any] = ["email": email, "password": password]
        
        ApiClient.shared.request(path: "/user/auth/login",method: "POST",body: body) { (result:Result<UserResponse, any Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    TokenStore.shared.jwt = response.data.token
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.isAuthenticated = true
                    }
                    self.isAuthenticated = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(self.errorMessage!)
                }
            }
        }
    }
    
    func registerUser() {
        isLoading = true
        let body: [String: Any] = ["email": email, "password": password]
        ApiClient.shared.request(path: "/user/auth/register",method: "POST",body: body) { (result:Result<UserResponse, any Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    TokenStore.shared.jwt = response.data.token
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func logOutUser(){
        ApiClient.shared.request(path: "/user/auth/logout",method: "POST") { (result:Result<logOutResponse, any Error>) in
            DispatchQueue.main.async {
                self.isAuthenticated = false
                TokenStore.shared.jwt = nil
                self.email = ""
                self.password = ""
                switch result {
                case .success(let response):
                    self.user = nil
                    print(response)
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
