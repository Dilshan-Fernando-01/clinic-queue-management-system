import SwiftUI

struct LandingView: View {
    
    @State private var navigateToDoctorList = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                ZStack {
                    Image("welcome_bg")
                        .scaledToFill()
                        .frame(height:430)
                        .overlay(
                            Image("LogoappLogo")
                                .resizable()
                                .frame(width: 180, height: 160)
                                .foregroundColor(.black.opacity(0.4))
                        )
                }

             
                VStack(alignment: .leading, spacing: 12) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()

                    Text("Lorem ipsum dolor sit amet consectetur.\nLorem id sit")
                        .foregroundColor(.gray)

                    Spacer()

                    HStack {
                        Spacer()
                    
                        Button(action: {
                            navigateToDoctorList = true
                        }) {
                            HStack(spacing: 10) {
                                Text("Continue")
                                    .foregroundColor(.gray)

                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(44)
            }
            
            .navigationDestination(isPresented: $navigateToDoctorList) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    LandingView()
}
