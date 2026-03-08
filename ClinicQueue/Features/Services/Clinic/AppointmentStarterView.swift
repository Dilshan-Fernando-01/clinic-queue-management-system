//
//  AppointmentStarterView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct AppointmentStarterView: View {
    @State private var selectedQueue: UUID? = nil
//    @State private var showModal = true
    
    private let doctorImage = Image("doctor01")
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
    ]
    
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
    
    @State private var selectedPaymentOption: String? = "card"
    @State private var navigateToPaymentView = false
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Your Clinic Queue")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                      
                    
                    InfoCard(data: doctorInfo)
                        .padding(.horizontal)
                        .padding(.top, Spacing.section)
                    
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
                    .padding(.top, Spacing.section)
                    
                    PaymentDetails(rows: paymentDetailsData)
                        .padding(.horizontal)
                        .padding(.top, Spacing.section)
                    
                    PaymentOptions(
                        items: paymentOptionsData,
                        selectedKey: $selectedPaymentOption
                    )
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                    
                    PrimaryButton(title: "Book Appointment") {
                        navigateToPaymentView = true
//                        withAnimation {
//                            showModal = true
//                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                }
                .padding(.vertical, 20)
                .navigationDestination(isPresented: $navigateToPaymentView) {
                    PaymentView()
                }
            }
//            CustomModal(isPresented: $showModal) {
//                VStack(spacing: 16) {
//                    Text("Hello from Modal")
//                        .font(.title2)
//                        .bold()
//                    
//                    Text("child elements")
//                        .multilineTextAlignment(.center)
//                    
//                    Button("Do Something") {
//                        print("Button tapped")
//                    }
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                }
//                .padding()
//            }
        }
    }
    
}

#Preview {
    AppointmentStarterView()
}
