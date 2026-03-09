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
    
    
    
    private let paymentDetailsData: [PaymentDetailRow] = [
        PaymentDetailRow(label: "Consultation", value: "$59.00"),
        PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
        PaymentDetailRow(label: "Additional Discount", value: "-"),
        PaymentDetailRow(label: "Total", value: "$70.00")
    ]
    
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
                                    currentVisit.doctorName = doctor?.heading
                                    currentVisit.specialty = doctor?.subheading
                                    currentVisit.queueNumber = queue?.heading
                                    currentVisit.status = "In Progress"
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
