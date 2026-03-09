//
//  DoctorAppointmentStarterView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

import SwiftUI

struct DoctorAppointmentStarterView: View {
    let doctor: InfoCardData

    @State private var selectedQueue: UUID? = nil
    @State private var selectedPaymentOption: String? = "card"
    @State private var navigateToPaymentView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Your Clinic Queue")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    
                    InfoCard(data: doctor)
                        .padding(.horizontal)
                        .padding(.top, Spacing.section)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Queues")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        QueueButtonGroup(
                            queues: doctor.availableDates?.map { date in
                                QueueOption(heading: formattedQueueHeading(for: date), subText: formattedQueueTime(for: date))
                            } ?? [],
                            selectedId: $selectedQueue
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                    
                    PrimaryButton(title: "Book Appointment") {
                        navigateToPaymentView = true
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                }
                .padding(.vertical, 20)
                .navigationDestination(isPresented: $navigateToPaymentView) {
                  
                        Text("Please select a queue")
                    }
                }
            }
        }
    }
    
    private func formattedQueueHeading(for date: DoctorAvailability) -> String {
        return date.queueLabel
    }
    
    private func formattedQueueTime(for date: DoctorAvailability) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date.date)
    }


