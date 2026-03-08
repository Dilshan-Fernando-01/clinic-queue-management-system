//
//  PaymentStatusView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct PaymentStatusView: View {
    
    let isSuccess: Bool
    
    private let paymentDetailsData: [PaymentDetailRow] = [
        PaymentDetailRow(label: "Consultation", value: "$59.00"),
        PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
        PaymentDetailRow(label: "Additional Discount", value: "-"),
        PaymentDetailRow(label: "Total", value: "$70.00")
    ]
    
    var body: some View {
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
                        
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    PaymentStatusView(isSuccess: true)
}
