//
//  PharPayemntForm.swift
//  ClinicQueue
//
//  Created by Roshan on 2026-03-12.
//




import SwiftUI

struct PharPayemntForm: View {
    @State private var nameOnCard = ""
    @State private var cardNumber = ""
    @State private var cvv = ""
    @State private var expirationDate = ""
    
    @State private var isOtpModalOpen = false
    @State private var isNavigateToPaymentProcess = false
    
    @State private var otpDigits: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    
    @State private var remainingSeconds = 349
    @State private var timer: Timer?
    
    var backgroundColor: Color = AppColors.primary

    @EnvironmentObject var sessionManager: SessionManager
    @State private var selectedPaymentOption: String? = "card"
    @State private var navigateToPaymentView = false

 


    private var paymentDetailsData: [PaymentDetailRow] {
        [
            PaymentDetailRow(label: "Imaging Tests",        value: "$ 50.00"),
            PaymentDetailRow(label: "Admin Fee",            value: "$ 1.00"),
            PaymentDetailRow(label: "Additional Discount",  value: "$ \(String(format: "00.00", PaymentConfig.additionalDiscount))"),
            PaymentDetailRow(label: "Total",                value: "$ 51.000")
        ]
    }

 
    private let paymentMethods = [
        PaymentMethod(name: "Apple Pay", iconName: "apple"),
        PaymentMethod(name: "Visa", iconName: "visa"),
        PaymentMethod(name: "MasterCard", iconName: "mastercard"),
        PaymentMethod(name: "PayPal", iconName: "paypal")
    ]
    
    

   

    var body: some View {
       
        NavigationStack {
            ZStack(alignment: .bottom) {

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        Text("Payment")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)

                        PaymentDetails(rows: paymentDetailsData)
                            .padding(.horizontal)
                            .padding(.top, Spacing.section)

                        PaymentMethodSelector(
                            title: "Choose Payment Method",
                            methods: paymentMethods
                        )
                        .padding(.horizontal)
                        .padding(.top, Spacing.section)

                        CardInfoForm(
                            nameOnCard: $nameOnCard,
                            cardNumber: $cardNumber,
                            cvv: $cvv,
                            expirationDate: $expirationDate
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 120) // space for sticky button
                    }
                }

                VStack(spacing: 0) {

                    LinearGradient(
                        colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 24)

                    HStack {
                        PrimaryButton(title: "Next", maxWidth: 220) {
                            navigateToPaymentView = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemBackground))
                }
            }
        }
    }
}

#Preview {
    PharPayemntForm()
}
