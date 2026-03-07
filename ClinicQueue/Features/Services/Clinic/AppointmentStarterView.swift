//
//  AppointmentStarterView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct AppointmentStarterView: View {
    @State private var selectedQueue: UUID? = nil
    @State private var selectedPaymentOption: String? = nil
    

    private let doctorImage = Image(systemName: "person.circle.fill")
    private let doctorHeading = "Dr. Jane Doe"
    private let doctorSubheading = "Cardiologist"
    private let doctorActiveQueue = "12 patients in queue"
    private let doctorDetail1: (label: String, value: String) =
    ("Estimated wait:", "~25 min")

    private let doctorDetail2: (label: String, value: String) =
    ("Location:", "Room 02 – Consultation Wing")

    private var doctorInfo: InfoCardData {
        InfoCardData(
            image: doctorImage,
            heading: doctorHeading,
            subheading: doctorSubheading,
            activeQueueCount: doctorActiveQueue,
            detail1: doctorDetail1,
            detail2: doctorDetail2
        )
    }

    private let queueOptions: [QueueOption] = [
        QueueOption(heading: "A1", subText: "09:00 AM"),
        QueueOption(heading: "A2", subText: "09:30 AM"),
        QueueOption(heading: "A3", subText: "10:00 AM")
    ]

    private let paymentDetailsData: [PaymentDetailRow] = [
        PaymentDetailRow(label: "Consultation", value: "$59.00"),
        PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
        PaymentDetailRow(label: "Additional Discount", value: "-"),
        PaymentDetailRow(label: "Total", value: "$70.00")
    ]

    private let paymentOptionsData: [CheckboxItem] = [
        CheckboxItem(key: "card", label: "Card Payment"),
        CheckboxItem(key: "cash", label: "Cash Payment")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Clinic Queue")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)

                InfoCard(data: doctorInfo)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Available Queues")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)

                    QueueButtonGroup(
                        queues: queueOptions,
                        selectedId: $selectedQueue
                    )
                }
                .padding(.horizontal)

                PaymentDetails(rows: paymentDetailsData)
                    .padding(.horizontal)

                PaymentOptions(
                    items: paymentOptionsData,
                    selectedKey: $selectedPaymentOption
                )
                .padding(.horizontal)

                PrimaryButton(title: "Book Appointment") {
                    print("Selected Queue:", selectedQueue ?? "")
                    print("Selected Payment Option:", selectedPaymentOption ?? "")
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
            }
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    AppointmentStarterView()
}
