//
//  PaymentView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct PaymentView: View {
    
    @State private var nameOnCard = ""
    @State private var cardNumber = ""
    @State private var cvv = ""
    @State private var expirationDate = ""
    
    private let paymentDetailsData: [PaymentDetailRow] = [
        PaymentDetailRow(label: "Consultation", value: "$59.00"),
        PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
        PaymentDetailRow(label: "Additional Discount", value: "-"),
        PaymentDetailRow(label: "Total", value: "$70.00")
    ]
    
    private let paymentMethods = [
        PaymentMethod(name: "Apple Pay", iconName: "apple"),
        PaymentMethod(name: "Visa", iconName: "visa"),
        PaymentMethod(name: "MasterCard", iconName: "mastercard"),
        PaymentMethod(name: "PayPal", iconName: "paypal")
    ]

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Payment")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                
                PaymentDetails(rows: paymentDetailsData)
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                
                PaymentMethodSelector(title: "Choose Payment Method", methods: paymentMethods)
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                
                CardInfoForm(
                           nameOnCard: $nameOnCard,
                           cardNumber: $cardNumber,
                           cvv: $cvv,
                           expirationDate: $expirationDate
                       )
                       .padding(.top, Spacing.section)
                
                
                PrimaryButton(title: "Book Appointment") {

                }
                .padding(.horizontal)
                .padding(.top, Spacing.section)
            }
           
        }
    }
}

#Preview {
    PaymentView()
}
