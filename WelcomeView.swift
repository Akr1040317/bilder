import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Fullscreen background image that ignores safe areas
            Image("Welcome")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Main content overlay
            VStack(alignment: .leading) {
                
                // Logo Row
                HStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    Spacer()
                }
                .padding(.top, 0)
                .padding(.horizontal, 80) // Added padding to prevent left-edge cutoff
                
                Spacer()
                
                // Heading Text
                Text("Get Fit,\nGet Strong,\nGet Connected!")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures alignment within the screen
                    .padding(.horizontal, 70)
                    .padding(.top, 180)

                // Subheading Text
                Text("Welcome to BILDER – the fitness community designed to connect, motivate, and challenge you. Find workout partners, join events, and reach your goals—together.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 2)
                    .padding(.horizontal, 70)

                Spacer()
                
                // Buttons Row
                HStack(spacing: 16) {
                    NavigationLink(destination: RegistrationView()) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(30)
                    }

                    NavigationLink(destination: LoginView()) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(30)
                            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.red, lineWidth: 2))
                    }
                }
                .padding(.horizontal, 70) // Added padding so buttons don’t touch the edges
                .padding(.bottom, 20)
            }
            .padding(.vertical, 16) // Ensuring padding applies properly
        }
        .navigationBarHidden(true)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeView()
        }
        .preferredColorScheme(.dark)
    }
}

