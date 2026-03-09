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
    
    
    
    private var paymentDetailsData: [PaymentDetailRow] {

        guard let visit = sessionManager.currentClinicVisit else { return [] }

        return [
            PaymentDetailRow(
                label: "Consultation",
                value: "$\(String(format: "%.2f", visit.consultationFee ?? 0))"
            ),
            PaymentDetailRow(
                label: "Admin Fee",
                value: "$\(String(format: "%.2f", visit.adminFee ?? 0))"
            ),
            PaymentDetailRow(
                label: "Additional Discount",
                value: "$\(String(format: "%.2f", PaymentConfig.additionalDiscount))"
            ),
            PaymentDetailRow(
                label: "Total",
                value: "$\(String(format: "%.2f", visit.totalPayment))"
            )
        ]
    }
    
    @EnvironmentObject var sessionManager: SessionManager
    
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

                        PrimaryButton(
                            title: isSuccess ? "Continue" : "Try Again"
                        ) {
                            if isSuccess {
                                if var currentVisit = sessionManager.currentClinicVisit {
                                    if var visit = sessionManager.currentClinicVisit, let doctor = doctor {

                                        var doctorStep = visit.doctorStep ?? ClinicStep(type: .doctor, name: doctor.heading)

                                        doctorStep.name = doctor.heading
                                        doctorStep.specialty = doctor.subheading
                                        doctorStep.queueNumber = queue?.heading

                                        let cleanedPrice = doctor.price?.replacingOccurrences(of: "$", with: "") ?? "0"
                                        doctorStep.price = Double(cleanedPrice) ?? 0

                                        visit.updateStep(doctorStep)
                                        sessionManager.currentClinicVisit = visit
                                    }
                                    if let priceString = doctor?.price {
                                        let cleanedPrice = priceString.replacingOccurrences(of: "$", with: "")
                                        currentVisit.consultationFee = Double(cleanedPrice) ?? 0
                                    } else {
                                        currentVisit.consultationFee = 0
                                    }
                               
                                    currentVisit.consultationFee = doctor?.price.flatMap { Double($0) } ?? 0
                                    currentVisit.adminFee = PaymentConfig.adminFee
                                    
                                 
                                    sessionManager.currentClinicVisit = currentVisit
                                }
                            }
                            
                            navigateNext = true
                        }
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
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

//#Preview {
//    PaymentStatusView(
//        isSuccess: true,
//        onContinue: { Text("Next Page") }
//    )
//}
