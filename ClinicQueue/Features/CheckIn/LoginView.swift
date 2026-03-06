// LoginView.swift
import SwiftUI

struct LoginView: View {
    @State private var navigateToPhoneEntry = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 22) {
                    
         
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 26, weight: .bold))
                        
                        Text("Sign in to manage your appointments and services")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    
                    // Phone Number Button with Navigation
                    PrimaryButton(title: "Continue with Phone Number") {
                        navigateToPhoneEntry = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    // Or continue with
                    HStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                        
                        Text("Or continue with")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                    
                    // Social Login Buttons
                    SocialLoginButton(
                        iconName: "applelogo",
                        text: "Sign in with Apple"
                    ) {
                        // Handle Apple Sign In
                    }
                    
                    SocialLoginButton(
                        iconName: "g.circle",
                        iconColor: .red,
                        text: "Sign in with Google"
                    ) {
                        // Handle Google Sign In
                    }
                    
                    // Guest Login
                    Text("Continue as Guest")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                // Navigation Link
                NavigationLink(
                    destination: PhoneNumberEntryView(),
                    isActive: $navigateToPhoneEntry
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
