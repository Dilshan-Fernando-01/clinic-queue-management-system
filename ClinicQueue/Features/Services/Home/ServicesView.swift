import SwiftUI

struct ServicesView: View {
    @EnvironmentObject var sessionManager: SessionManager
    private let services: [Service] = [
        Service(
            icon: "stethoscope",
            title: "Consultation Today",
            subtitle: "Complete clinic visit and treatment process.",
            background: Color(red: 247/255, green: 246/255, blue: 255/255),
            destination: .consultation
        ),
        Service(
            icon: "testtube.2",
            title: "Laboratory",
            subtitle: "Blood tests and diagnostic services.",
            background: Color(red: 232/255, green: 243/255, blue: 232/255),
            destination: .laboratory
        ),
        Service(
            icon: "hand.raised",
            title: "Imaging",
            subtitle: "X-ray and medical imaging services.",
            background: Color(red: 255/255, green: 249/255, blue: 232/255),
            destination: .imaging
        ),
        Service(
            icon: "pills",
            title: "Pharmacy",
            subtitle: "Collect prescribed medicines and supplies.",
            background: Color(red: 240/255, green: 242/255, blue: 246/255),
            destination: .pharmacy
        )
    ]
    
    @ViewBuilder
    private func destinationView(for service: Service) -> some View {
        switch service.destination {
        case .consultation:
            PatientDetailsFormView()
        case .laboratory:
            LabList()
        case .imaging:
            ImageList()
            Text("Imaging View")
        case .pharmacy:
            Text("Pharmacy View")
        case .appointment:
            FindDoctorView()
        @unknown default:
            EmptyView()
        }
    }
    
    private let doctorAppointmentService = Service(
          icon: "calendar",
          title: "Doctor Appointment",
          subtitle: "Book and manage doctor appointments.",
          background: Color(red: 247/255, green: 246/255, blue: 255/255),
          destination: .appointment
      )

    var body: some View {
        NavigationStack {
            if let visit = sessionManager.currentClinicVisit, !visit.isSessionComplete,
                let step = visit.doctorStep {

                
                 let nowServing = Int(step.nowServing ?? "2") ?? 0
                 let queueNumber = Int(step.queueNumber ?? "0") ?? 0
                 let maxQueue = 10
                 let progress = min(max(((queueNumber - nowServing + 1) * 100) / maxQueue, 0), 100)

                 NavigationLink(
                     destination: Queue(),
                     label: {
                         ActiveQueueBanner(
                             title: "Your Queue: \(step.name ?? "Doctor")",
                             description: "Queue Number: \(step.queueNumber ?? "--"), Estimated Wait: \(step.estimatedWait ?? "--")",
                             queueNumber: step.queueNumber ?? "--",
                             progress: progress,
                             onNavTap: {}
                         )
                         .padding(.bottom, 10)
                     }
                 )
             }
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Find your desire")
                                    .font(.system(size: 26, weight: .bold))
                                
                                Text("health solution")
                                    .font(.system(size: 26, weight: .bold))
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                
                                NavigationLink(destination: NotificationView()) {
                                    Image(systemName: "bell")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }

                                NavigationLink(destination: ProfileView()) {   
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Text("KL")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        )
                                }
                            }
                        }
                        
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(services) { service in
                                NavigationLink(destination: destinationView(for: service)) {
                                    ServiceCard(service: service)
                                        .frame(height: 190)
                                }
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Doctor Channeling")
                                .font(.title2.weight(.bold))
                            
                            Text("Reserve your appointment with a doctor at your preferred date and time.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 8)
                        
                        
                        NavigationLink(destination: FindDoctorView()) {
                            CenteredServiceCard(
                                service: Service(
                                    icon: "calendar",
                                    title: "Doctor Appointment",
                                    subtitle: "Book and manage doctor appointments.",
                                    background: Color(red: 247/255, green: 246/255, blue: 255/255),
                                    destination: .appointment
                                )
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 32)
                }
                
                
                FloatingNav(
                    mainIcon: "plus",
                    items: [
                        FloatingNavItem(icon: "house.fill", label: "Home", destination: AnyView(EmptyView())),
                        FloatingNavItem(icon: "map.fill", label: "Map", destination: AnyView(Text("Map View"))),
                        FloatingNavItem(icon: "gearshape.fill", label: "Settings", destination: AnyView(ProfileView()))
                    ]
                )
            }
        }
    }
}

struct ServicesView_Previews_Fixed: PreviewProvider {
    static var previews: some View {
        ServicesView()
            .environmentObject(SessionManager())
    }
}
