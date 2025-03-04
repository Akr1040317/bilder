//
//  LoginView.swift
//  Bilder
//
//  Created by Akshat Rastogi on 2/11/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    // Fields for email/password login
    @State private var email: String = ""
    @State private var password: String = ""
    
    // State for alerts
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.presentationMode) var presentationMode // To go back

    var body: some View {
        ZStack {
            // Background – Dark Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                // HStack containing back chevron and logo
                HStack {
                    // Fixed-width back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .frame(width: 40) // Force the button's width to 40

                    Spacer()

                    // Logo in the center
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    Spacer()

                    // Symmetrical placeholder with the same width as the back button
                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Title
                Text("Welcome Back")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Text Fields
                VStack(spacing: 15) {
                    CustomLabeledTextField(label: "Email", placeholder: "example@mail.com", text: $email)
                    CustomLabeledSecureField(label: "Password", placeholder: "Enter your password", text: $password)
                }
                .padding(.horizontal, 20)
                
                // Login Button
                Button(action: {
                    authViewModel.signIn(email: email, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .frame(width: 200, height: 50) // Match the smaller width style
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
                // "Or sign in with" text
                Text("Or sign in with")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.subheadline)
                    .padding(.top, 10)
                
                // Social Login Buttons
                HStack(spacing: 15) {
                    // Google Sign-In Button
                    SocialLoginButton(icon: "Google", text: "Google") {
                        Task {
                            do {
                                try await authViewModel.signInWithGoogle()
                                alertMessage = "Successfully signed in with Google!"
                                showAlert = true
                            } catch {
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    
                    // Facebook button (action not implemented)
                    SocialLoginButton(icon: "Facebook", text: "Facebook") {
                        alertMessage = "Facebook sign in is not implemented yet."
                        showAlert = true
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        // Show alert
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        // Whenever authViewModel.errorMessage changes, display it in an alert
        .onChange(of: authViewModel.errorMessage) { newValue in
            if let newValue = newValue {
                alertMessage = newValue
                showAlert = true
            }
        }
    }
}


// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

