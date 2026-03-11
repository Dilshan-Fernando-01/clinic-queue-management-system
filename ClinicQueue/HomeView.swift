import SwiftUI

struct HomeView: View {
    @State private var navigateToDoctor = false
    @StateObject private var sessionManager = SessionManager()

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 16) {
                  LandingView()
                        .environmentObject(sessionManager)
                }
                .padding()
            }
          
            .navigationDestination(isPresented: $navigateToDoctor) {
                DoctorListView()
                .padding(.horizontal, 16)
                .navigationBarHidden(true)
            }
        }
    }
}

