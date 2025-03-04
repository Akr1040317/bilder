//
//  InputView.swift
//  Bilder
//
//  Created by Akshat Rastogi on 2/11/25.
//


// InputView.swift

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var placeholderColor: Color = .black.opacity(0.4) // Default placeholder color set to black

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.black))
                .fontWeight(.semibold)
                .font(.footnote)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(placeholderColor) // Use the customizable placeholder color
                        .padding(.horizontal, 16) // Align placeholder text with user input
                }
                
                if isSecureField {
                    SecureField("", text: $text)
                        .padding(8)
                        .foregroundColor(.black) // Ensure user input is visible
                } else {
                    TextField("", text: $text)
                        .padding(8)
                        .foregroundColor(.black) // Ensure user input is visible
                        .autocapitalization(.none)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 3) // Set border color and width
            )
            
            Divider()
        }
    }
}

