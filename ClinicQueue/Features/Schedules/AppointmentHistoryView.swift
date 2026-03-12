import SwiftUI

struct AppointmentHistoryView: View {
    
    @StateObject var session = SessionManagerV2()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Appointment History")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                
                let todayAppointments = session.upcomingAppointments.filter {
                    Calendar.current.isDateInToday($0.date)
                }
                
                let futureAppointments = session.upcomingAppointments.filter {
                    $0.date > Date()
                }
                
                let completedAppointments = session.upcomingAppointments.filter {
                    $0.date < Date()
                }
                
              
                if !todayAppointments.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        ForEach(todayAppointments) { appointment in
                            InfoCard(
                                data: createCardData(from: appointment, isToday: true)
                            )
                            .padding(.horizontal)
                            .onTapGesture {
                                goToQueuePage(appointment)
                            }
                        }
                    }
                } else {
                    Text("No appointments today")
                        .foregroundColor(.gray)
                        .padding()
                }
                
           
                if !futureAppointments.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        ForEach(futureAppointments) { appointment in
                            InfoCard(
                                data: createCardData(from: appointment, isToday: false)
                            )
                            .padding(.horizontal)
                            .opacity(0.5)
                        }
                    }
                }
                
          
                if !completedAppointments.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Completed")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        ForEach(completedAppointments) { appointment in
                            InfoCard(
                                data: createCardData(from: appointment, isToday: false)
                            )
                            .padding(.horizontal)
                            .opacity(0.5)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            session.upcomingAppointments = DummyAppointments.generate()
        }
    }
    
 
    private func goToQueuePage(_ appointment: UpcomingAppointment) {
        print("➡️ Going to queue for patient: \(appointment.patientName ?? "-")")

        for (index, activity) in appointment.activities.enumerated() {
            print("Activity \(index + 1): \(activity.service.rawValue.capitalized)")
            
            if let doctor = activity.selectedDoctor {
                print("Doctor: \(doctor.heading) (\(doctor.subheading))")
            }

            if let lab = activity.labStep {
                print("Lab Test: \(lab.name) | Wait: \(lab.estimatedWait ?? "-") | Location: \(lab.location ?? "-")")
            }

            if let imaging = activity.imagingStep {
                print("Imaging Test: \(imaging.name) | Wait: \(imaging.estimatedWait ?? "-") | Location: \(imaging.location ?? "-")")
            }

            if activity.symptoms.count > 0 {
                print("   Symptoms: \(activity.symptoms.joined(separator: ", "))")
            }

            if let queue = activity.queueNumber {
                print("   Queue Number: \(queue)")
            }

            print("----------------------------")
        }
    }
    
    private func createCardData(from appointment: UpcomingAppointment, isToday: Bool) -> InfoCardData {
   
        let doctor = appointment.activities.first?.selectedDoctor
        
        return InfoCardData(
            image: doctor?.image ?? Image(systemName: "person.crop.circle.fill"),
            heading: doctor?.heading ?? "Doctor",
            subheading: doctor?.subheading ?? "-",
            activeQueueCount: doctor?.activeQueueCount,
            detail1: ("Queue", doctor?.activeQueueCount ?? "-"),
            detail2: ("Location", doctor?.detail2?.value ?? "-"),
            price: "$\(String(format: "%.2f", appointment.totalFee))",
            availableDates: doctor?.availableDates,
            maxPatientsPerDay: doctor?.maxPatientsPerDay,
            isPriceButtonVisble: true,
            status: isToday || appointment.date > Date() ? .upcoming : .completed
        )
    }
}

#Preview {
    AppointmentHistoryView()
}
