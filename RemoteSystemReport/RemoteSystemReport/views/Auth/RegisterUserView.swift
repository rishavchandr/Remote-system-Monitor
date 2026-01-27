//
//  RegisterUserView.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 25/01/26.
//

import SwiftUI

struct RegisterUserView: View {
    @ObservedObject var vm: AuthViewModel
    @State private var showLoginView = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(hex: "1a1a1a"), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: 100, y: -200)
                
                VStack(spacing: 30) {
                    
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .padding(.bottom, 10)
                        
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Join us and start monitoring")
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
                            vm.registerUser()
                        }
                    } label: {
                        HStack {
                            if vm.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign Up")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 10)
                    }
                    .disabled(vm.isLoading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        showLoginView = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
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
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView(vm: vm)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RegisterUserView(vm: AuthViewModel())
}
