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
    @State private var isOtpModalOpen = false
    @State private var otpDigits: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    
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
        ZStack { 
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
                        isOtpModalOpen = true
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                }
            }
            
            if isOtpModalOpen {
                CustomModal(isPresented: $isOtpModalOpen) {
                    VStack(spacing: 16) {
                        Text("Please enter the OTP code you received on your (079 878 8779) phone.")
                            .font(.subheadline)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 6) {
                            ForEach(0..<4, id: \.self) { index in
                                OTPDigitBox(
                                    digit: $otpDigits[index],
                                    isFocused: focusedField == index
                                )
                                .focused($focusedField, equals: index)
                                .onChange(of: otpDigits[index]) { newValue in
                                    handleOTPInput(at: index, newValue: newValue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 0)
                        
                        Text("The OTP code will expire in ")
                            .foregroundColor(AppColors.lableColor)
                            .font(.system(size: 15))
                        + Text("5 minutes and 49 seconds.")
                            .foregroundColor(AppColors.dark)
                            .font(.system(size: 15))
                        
                        PrimaryButton(title: "Confirm") {
                            isOtpModalOpen = false
                        }
                        LinkButton(title: "Resend", textColor: AppColors.placeholder) {
                            print("Link tapped")
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private func handleOTPInput(at index: Int, newValue: String) {

        if newValue.count > 1 {
            otpDigits[index] = String(newValue.prefix(1))
        }
        

        if !newValue.isEmpty && index < 3 {
            focusedField = index + 1
        }
        
     
        if index == 3 && !newValue.isEmpty {
            focusedField = nil
           
        }
    }
}




#Preview {
    PaymentView()
}
