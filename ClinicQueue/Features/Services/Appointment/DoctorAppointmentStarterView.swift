//
//  DoctorAppointmentStarterView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

import SwiftUI

private let paymentDetailsData: [PaymentDetailRow] = [
    PaymentDetailRow(label: "Consultation", value: "$59.00"),
    PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
    PaymentDetailRow(label: "Additional Discount", value: "-"),
    PaymentDetailRow(label: "Total", value: "$70.00")
]
private let paymentOptionsData: [CheckboxItem] = [
    CheckboxItem(
        key: "card",
        label: "Card Payment",
        icon: Image("Card")
    ),
    CheckboxItem(key: "cash", label: "Cash Payment", icon: Image("Cash"))
]

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
                    
                    
                    PaymentDetails(rows: paymentDetailsData)
                        .padding(.top, Spacing.section)
                    
                    PaymentOptions(
                        items: paymentOptionsData,
                        selectedKey: $selectedPaymentOption
                    )
                    
                    .padding(.top, Spacing.section)
                    
                    
                    PrimaryButton(title: "Book Appointment") {
                        navigateToPaymentView = true
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                }
                .padding()
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


extension InfoCardData {
    static let mock = InfoCardData(
        image: Image("doctor_placeholder"),
        heading: "Dr. John Doe",
        subheading: "Cardiologist",
        price: "$50",
        availableDates: []
    )
}


#Preview {
    NavigationStack {
        DoctorAppointmentStarterView(doctor: .mock)
    }
}
