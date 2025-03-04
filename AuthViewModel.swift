//
//  AuthViewModel.swift
//  Bilder
//
//  Created by [Your Name] on [Date].
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    // Published properties to update the UI as authentication state changes.
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var userSession: User?
    
    // Optionally, check the current user at initialization
    init() {
        self.user = Auth.auth().currentUser
        self.isLoggedIn = (self.user != nil)
        self.userSession = self.user
    }
    
    /// Registers a new user with email and password.
    /// On success, creates a Firestore document in "users" and "usernames".
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's password.
    ///   - username: Chosen username.
    func registerUser(withEmail email: String, password: String, username: String) async throws {
        // Create the user in Firebase Authentication.
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        self.user = result.user
        self.isLoggedIn = true
        self.errorMessage = nil
        
        // Get a reference to Firestore.
        let db = Firestore.firestore()
        
        // Save user data in "users" collection.
        let userData: [String: Any] = [
            "createdAt": Timestamp(date: Date()),
            "username": username,
            "email": email,
            "signUpMethod": "email",
            "uid": result.user.uid
        ]
        try await db.collection("users").document(result.user.uid).setData(userData)
        
        // Save the username to a separate "usernames" collection.
        let usernameData: [String: Any] = [
            "createdAt": Timestamp(date: Date()),
            "username": username,
            "uid": result.user.uid
        ]
        try await db.collection("usernames").document(username).setData(usernameData)
    }
    
    /// Signs in an existing user with email and password.
    /// (This method remains unchanged from your original code.)
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoggedIn = false
                    self.user = nil
                } else if let result = result {
                    self.user = result.user
                    self.userSession = result.user
                    self.isLoggedIn = true
                    self.errorMessage = nil
                }
            }
        }
    }
    
    /// Signs in with Google.
    /// This method uses the async/await version of the GoogleSignIn API.
    func signInWithGoogle() async throws {
            // Ensure that FirebaseApp has a clientID.
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw NSError(domain: "MissingClientID", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Firebase client ID."])
            }
            // (If needed, you can log or otherwise use clientID.)
            
            // Get the top‑most view controller to present the Google sign in.
            guard let presentingVC = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows.first?.rootViewController else {
                throw NSError(domain: "NoRootViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller found."])
            }
            
            // Start the Google sign in flow.
            // Use the updated async/await API that only requires the presenting view controller.
            let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
            
            // Extract the ID token and access token.
            // (Note: Depending on your GoogleSignIn SDK version, the properties may be nested differently.)
            guard let idToken = signInResult.user.idToken?.tokenString else {
                throw NSError(domain: "MissingIDToken", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Google ID token."])
            }
            let accessToken = signInResult.user.accessToken.tokenString
            
            // Create a Firebase credential from the Google tokens.
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // Sign in with Firebase.
            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
            self.user = result.user
            self.isLoggedIn = true
            self.errorMessage = nil
            
            // Save the user to the "users" collection in Firestore.
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "createdAt": Timestamp(date: Date()),
                "username": "", // Leave empty for Google sign in
                "email": result.user.email ?? "",
                "signUpMethod": "google",
                "uid": result.user.uid
            ]
            try await db.collection("users").document(result.user.uid).setData(userData)
        }
    
    /// Signs out the current user.
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.userSession = nil
            self.isLoggedIn = false
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

