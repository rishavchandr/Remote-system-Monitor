//
//  LoginView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: AuthViewModel
    @State private var showRegisterUserView = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(hex: "1a1a1a"), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: -100, y: -200)
                
                VStack(spacing: 30) {
                    
                    VStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .padding(.bottom, 10)
                        
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Sign in to monitor your systems")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email Address", text: $vm.email)
                                .textInputAutocapitalization(.never)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            
                            if isPasswordVisible {
                                TextField("Password", text: $vm.password)
                                    .foregroundColor(.white)
                            } else {
                                SecureField("Password", text: $vm.password)
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                    Button {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            vm.login()
                        }
                    } label: {
                        HStack {
                            if vm.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Login")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 10)
                    }
                    .disabled(vm.isLoading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        showRegisterUserView = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .font(.footnote)
                    }
                    .padding(.bottom, 20)
                }
                
                if let error = vm.errorMessage {
                    VStack {
                        Spacer()
                        ErrorToast(message: error) {
                            withAnimation { vm.clearErrorMessage() }
                        }
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(1)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation { vm.clearErrorMessage() }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showRegisterUserView) {
            RegisterUserView(vm: vm)
        }
        .onAppear {
            UserDefaults.standard.removeObject(forKey: "jwt")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    LoginView(vm: AuthViewModel())
}
