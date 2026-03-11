//
//  PaymentStatusView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct PaymentStatusView<NextDestination: View>: View {
    let isSuccess: Bool
    let doctor: InfoCardData?
    let queue: QueueOption?
    let onContinue: () -> NextDestination
    let currentVisit: ClinicVisit?

    @State private var navigateNext = false
    @EnvironmentObject var session: SessionManagerV2
    @EnvironmentObject var sessionManager: SessionManager

    private var paymentDetailsData: [PaymentDetailRow] {
        guard let visit = sessionManager.currentClinicVisit else { return [] }

        return [
            PaymentDetailRow(label: "Consultation", value: "$\(String(format: "%.2f", visit.consultationFee ?? 0))"),
            PaymentDetailRow(label: "Admin Fee", value: "$\(String(format: "%.2f", visit.adminFee ?? 0))"),
            PaymentDetailRow(label: "Additional Discount", value: "$\(String(format: "%.2f", PaymentConfig.additionalDiscount))"),
            PaymentDetailRow(label: "Total", value: "$\(String(format: "%.2f", visit.totalPayment))")
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text(isSuccess ? "Payment Successful" : "Payment Failed")
                            .font(.title2)
                            .fontWeight(.bold)

                        Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(isSuccess ? .green : .red)

                        Text(
                            isSuccess
                            ? "Your payment has been received."
                            : "Something went wrong while processing your payment."
                        )
                        .foregroundColor(AppColors.lableColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                        PaymentDetails(rows: paymentDetailsData)
                            .padding(.horizontal)
                            .padding(.top, Spacing.section)

                        PrimaryButton(title: isSuccess ? "Continue" : "Try Again") {
                            navigateNext = true
                        }
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        guard isSuccess, var visit = sessionManager.currentClinicVisit else { return }

                        if let doctor = doctor {
                            var doctorStep = visit.doctorStep ?? ClinicStep(type: .doctor, name: doctor.heading)
                            doctorStep.name = doctor.heading
                            doctorStep.specialty = doctor.subheading
                            doctorStep.queueNumber = queue?.heading
                            if let priceString = doctor.price?.replacingOccurrences(of: "$", with: "") {
                                doctorStep.price = Double(priceString) ?? 0
                            } else {
                                doctorStep.price = 0
                            }
                            visit.updateStep(doctorStep)

                            visit.consultationFee = doctorStep.price
                            visit.adminFee = PaymentConfig.adminFee
                            sessionManager.currentClinicVisit = visit
                        }

                        let currentServiceType = session.currentService

                            // 2️⃣ Find the selected activity for this service
                            if let selectedActivityIndex = session.activities.firstIndex(where: { activity in
                                activity.service == currentServiceType && activity.isSelected
                            }) {
                                // 3️⃣ Update only this activity
                                session.activities[selectedActivityIndex].queueStage = .wait
                                session.activities[selectedActivityIndex].stage = .inQueue

                                // Optional debug
                                print("✅ Updated selected activity for service \(currentServiceType):")
                                let updatedActivity = session.activities[selectedActivityIndex]
                                print("""
                                    - id: \(updatedActivity.id)
                                    - service: \(updatedActivity.service)
                                    - queueStage: \(updatedActivity.queueStage)
                                    - stage: \(updatedActivity.stage)
                                    - selected: \(updatedActivity.isSelected)
                                """)
                            }

                        session.printAllActivities()
                    }
                }

                FloatingNav(
                    mainIcon: "plus",
                    items: [
                        FloatingNavItem(icon: "house.fill", label: "Home", destination: AnyView(ServicesView())),
                        FloatingNavItem(icon: "map.fill", label: "Map", destination: AnyView(Text("Map View"))),
                        FloatingNavItem(icon: "gearshape.fill", label: "Settings", destination: AnyView(SettingsView()))
                    ]
                )
            }
            .navigationDestination(isPresented: $navigateNext) {
                onContinue()
            }
        }
    }
}
