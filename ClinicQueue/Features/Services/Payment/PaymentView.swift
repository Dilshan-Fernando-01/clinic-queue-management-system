//
//  PaymentView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct PaymentView<SuccessDestination: View>: View {
    
    let onPaymentSuccess: () -> SuccessDestination
    
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
        
        NavigationStack {
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
                        .padding(.top, Spacing.section)
                        
                        PrimaryButton(title: "Book Appointment") {
                            isOtpModalOpen = true
                            resetOtpTimer()
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
                            
                            
                            Group {
                                if remainingSeconds > 0 {
                                    
                                    Text("The OTP code will expire in ")
                                        .foregroundColor(AppColors.lableColor)
                                    +
                                    Text(formatTime())
                                        .foregroundColor(AppColors.dark)
                                    
                                } else {
                                    
                                    Text("OTP expired")
                                        .foregroundColor(AppColors.error)
                                }
                            }
                            .font(.system(size: 15))
                            
                            
                            PrimaryButton(title: "Confirm") {
                                
                                timer?.invalidate()
                                isOtpModalOpen = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isNavigateToPaymentProcess = true
                                }
                            }
                            
                            
                            LinkButton(
                                title: "Resend",
                                textColor: AppColors.placeholder
                            ) {
                                otpDigits = Array(repeating: "", count: 4)
                                resetOtpTimer()
                            }
                        }
                        .padding()
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
            
            
            
            .navigationDestination(isPresented: $isNavigateToPaymentProcess) {
                PaymentProcessingView(destination: onPaymentSuccess())
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
    
    

    private func startOtpTimer() {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    
    private func resetOtpTimer() {
        remainingSeconds = 349
        startOtpTimer()
    }
    
    
    private func formatTime() -> String {
        
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        return String(format: "%d minutes and %02d seconds", minutes, seconds)
    }
}

#Preview {
    PaymentView {
        PaymentStatusView(
            isSuccess: true,
            onContinue: { Text("Next Page") }
        )
    }
}
