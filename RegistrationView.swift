//
//  RegistrationView.swift
//  Bilder
//
//  Created by Akshat Rastogi on 2/11/25.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // State variables to control alert messages
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.presentationMode) var presentationMode // To go back to WelcomeView

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
                Text("Create an Account")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Text Fields
                VStack(spacing: 15) {
                    CustomLabeledTextField(label: "Username", placeholder: "Enter your username", text: $username)
                    CustomLabeledTextField(label: "Email", placeholder: "example@mail.com", text: $email)
                    CustomLabeledSecureField(label: "Password", placeholder: "Enter your password", text: $password)
                    CustomLabeledSecureField(label: "Confirm Password", placeholder: "Re-enter your password", text: $confirmPassword)
                }
                .padding(.horizontal, 20)
                
                // Register Button (Smaller Width)
                Button(action: {
                    // Check if passwords match first
                    if password != confirmPassword {
                        alertMessage = "Passwords do not match."
                        showAlert = true
                        return
                    }
                    // Use a Task to call our async view model method
                    Task {
                        do {
                            try await authViewModel.registerUser(withEmail: email, password: password, username: username)
                            alertMessage = "Successfully registered!"
                            showAlert = true
                        } catch {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }) {
                    Text("Register")
                        .font(.headline)
                        .frame(width: 200, height: 50) // Smaller width
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

                // "Or sign up with" text
                Text("Or sign up with")
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
        // Show an alert whenever showAlert is true
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Custom Labeled Text Fields
struct CustomLabeledTextField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .foregroundColor(.white)
                .font(.subheadline)
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
                .autocapitalization(.none)
                .placeholderStyle()
        }
    }
}

struct CustomLabeledSecureField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .foregroundColor(.white)
                .font(.subheadline)
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

// MARK: - Social Login Button
/// This version accepts an action closure so that the parent view can decide what happens on tap.
struct SocialLoginButton: View {
    var icon: String
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(icon) // Replace with your actual asset name if needed
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(text)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.white.opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - Placeholder Style Modifier
extension View {
    func placeholderStyle() -> some View {
        self.foregroundColor(Color.white.opacity(0.6)) // Lighter placeholder text
    }
}

// MARK: - Preview
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegistrationView()
        }
    }
}

