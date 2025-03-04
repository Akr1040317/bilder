//
//  AppDelegate.swift
//  Bilder
//
//  Created by Akshat Rastogi on 2/12/25.
//


import UIKit
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    // This method handles the URL that your app receives at the end of the Google Sign In flow.
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // If you use scene-based life cycle (default in SwiftUI apps), you may not need additional code.
}
