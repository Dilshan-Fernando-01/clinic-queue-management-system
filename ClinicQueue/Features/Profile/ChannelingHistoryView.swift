//
//  ChannelingHistoryView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-11.
//


import SwiftUI


enum ChannelingStatus {
    case completed
    case cancelled
    case upcoming

    var label: String {
        switch self {
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .upcoming:  return "Upcoming"
        }
    }

    var color: Color {
        switch self {
        case .completed: return .green
        case .cancelled: return .red
        case .upcoming:  return .blue
        }
    }
}


struct ChannelingHistory: Identifiable {
    let id = UUID()
    let doctorName: String
    let specialization: String
    let date: String
    let total: String
    let status: ChannelingStatus
}


struct ChannelingHistoryRow: View {
    let item: ChannelingHistory

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.doctorName)
                        .font(.system(size: 15, weight: .bold))

                    Text(item.specialization)
                        .font(.system(size: 13))
                        .foregroundColor(.blue)

                    Text(item.date)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                Text("Total: \(item.total)")
                    .font(.system(size: 13, weight: .semibold))
            }

            Text(item.status.label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(item.status.color)
                .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
    }
}


struct ChannelingHistoryView: View {

    @StateObject private var session = SessionManagerV2()
    @State private var navigateToQueue = false

    var body: some View {
        NavigationStack {

            ScrollView {

                VStack(spacing: 30) {


                    let todayAppointments = session.upcomingAppointments.filter {
                        Calendar.current.isDateInToday($0.date)
                    }

                    if !todayAppointments.isEmpty {

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Today")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)

                            ForEach(todayAppointments) { appointment in
                                ChannelingHistoryRow(
                                    item: mapAppointment(appointment)
                                )
                                .background(Color.blue.opacity(0.08))
                                .cornerRadius(8)
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

                    let futureAppointments = session.upcomingAppointments.filter {
                        $0.date > Date() &&
                        !Calendar.current.isDateInToday($0.date)
                    }

                    if !futureAppointments.isEmpty {

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Upcoming")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)

                            ForEach(futureAppointments) { appointment in
                                ChannelingHistoryRow(
                                    item: mapAppointment(appointment)
                                )
                                .opacity(0.6)
                                .padding(.horizontal)
                            }
                        }
                    }


                    let completedAppointments = session.upcomingAppointments.filter {
                        $0.date < Date()
                    }

                    if !completedAppointments.isEmpty {

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Completed")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)

                            ForEach(completedAppointments) { appointment in
                                ChannelingHistoryRow(
                                    item: mapAppointment(appointment)
                                )
                                .opacity(0.6)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(white: 0.96))
            .navigationTitle("My Channelings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                session.upcomingAppointments = DummyAppointments.generate()
            }
            .navigationDestination(isPresented: $navigateToQueue) {
                Queue()
                    .environmentObject(session)
            }
        }
    }


    private func mapAppointment(_ appointment: UpcomingAppointment) -> ChannelingHistory {

        let doctor = appointment.activities.first?.selectedDoctor

        let status: ChannelingStatus

        if appointment.date > Date() {
            status = .upcoming
        } else {
            status = .completed
        }

        return ChannelingHistory(
            doctorName: doctor?.heading ?? "Doctor",
            specialization: doctor?.subheading ?? "-",
            date: formattedDate(appointment.date),
            total: "$\(String(format: "%.2f", appointment.totalFee))",
            status: status
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd 'at' hh:mm a"
        return formatter.string(from: date)
    }


    private func goToQueuePage(_ appointment: UpcomingAppointment) {

        session.activities = appointment.activities

        if !session.activities.isEmpty {
            session.activities[0].isSelected = true
            session.activities[0].queueStage = .wait
        }

        session.currentService = .appointment
        navigateToQueue = true
    }
}

#Preview {
    ChannelingHistoryView()
}
