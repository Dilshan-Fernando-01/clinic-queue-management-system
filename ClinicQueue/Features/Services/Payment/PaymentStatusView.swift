//
//  PaymentStatusView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct PaymentStatusView<NextDestination: View>: View {
    let isSuccess: Bool
    let onContinue: () -> NextDestination
    @State private var navigateNext = false
    
    private let paymentDetailsData: [PaymentDetailRow] = [
        PaymentDetailRow(label: "Consultation", value: "$59.00"),
        PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
        PaymentDetailRow(label: "Additional Discount", value: "-"),
        PaymentDetailRow(label: "Total", value: "$70.00")
    ]
    
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

#Preview {
    PaymentStatusView(
        isSuccess: true,
        onContinue: { Text("Next Page") }
    )
}
