//
//  LabTestDetailsView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct LabTestDetailsView: View {
    @EnvironmentObject var sessionManager: SessionManagerV2

    // ✅ Receive selected cards from LabList
    let selectedLabCards: [LabCardData]

    var backgroundColor: Color = AppColors.primary
    @State private var navigateToPaymentView = false
    @State private var selectedPaymentOption: String? = "card"

    private var adminFee: Double {
        PaymentConfig.adminFee
    }

    // ✅ Compute total price from the passed-in selected cards
    private var totalPrice: Double {
        selectedLabCards.reduce(0.0) { sum, card in
            // Parse fee string like "$25.00" → 25.00
            let cleaned = card.buttonText
                .replacingOccurrences(of: "$", with: "")
                .trimmingCharacters(in: .whitespaces)
            return sum + (Double(cleaned) ?? 0)
        }
    }

    private var totalPayment: Double {
        totalPrice + adminFee - PaymentConfig.additionalDiscount
    }

    private var paymentDetailsData: [PaymentDetailRow] {
        [
            PaymentDetailRow(label: "Lab Tests",           value: "$ \(String(format: "%.2f", totalPrice))"),
            PaymentDetailRow(label: "Admin Fee",           value: "$ \(String(format: "%.2f", adminFee))"),
            PaymentDetailRow(label: "Additional Discount", value: "$ \(String(format: "%.2f", PaymentConfig.additionalDiscount))"),
            PaymentDetailRow(label: "Total",               value: "$ \(String(format: "%.2f", totalPayment))")
        ]
    }

    private let paymentOptionsData: [CheckboxItem] = [
        CheckboxItem(key: "card", label: "Card Payment", icon: Image("Card")),
        CheckboxItem(key: "cash", label: "Cash Payment", icon: Image("Cash"))
    ]

    private var visitBinding: Binding<ClinicVisit> {
        Binding(
            get: {
                sessionManager.currentClinicVisit ?? ClinicVisit(patientName: "Unknown", age: 0, gender: "-")
            },
            set: { sessionManager.currentClinicVisit = $0 }
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Lab Tests")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)

                // ✅ Show each selected lab card passed from LabList
                ForEach(Array(selectedLabCards.enumerated()), id: \.element.id) { index, card in
                    VStack(alignment: .leading, spacing: 16) {

                        BloodTestCard(
                            image: TestDataset.imageName(for: card.title),
                            title: card.title,
                            specialText: "Lab Test",
                            detailLine1: "\(card.label1)\(card.label1Text)",
                            detailLine2: "\(card.label2)\(card.label2Text)",
                            showExtraSection: true,
                            bottomTitleLeft: "Requirements",
                            listItems: ["No special preparation needed", "Bring your lab request form"],
                            bottomTitleRight: "Approx Time",
                            bottomSubTextRight: card.label1Text,
                            fee: card.buttonText,
                            isActiveQueue: false
                        )

                        if index < selectedLabCards.count - 1 {
                            Divider().padding(.vertical, 8)
                        }
                    }
                }

                PaymentDetails(rows: paymentDetailsData)
                    .padding(.top, Spacing.section)
                    .padding(.horizontal, 10)

                PaymentOptions(
                    items: paymentOptionsData,
                    selectedKey: $selectedPaymentOption
                )
                .padding(.top, Spacing.section)
                .padding(.horizontal, 10)

                HStack {
                    PrimaryButton(title: "Booking", maxWidth: 220) {
                        if var visit = sessionManager.currentClinicVisit {
                            visit.consultationFee = totalPrice
                            visit.adminFee = adminFee
                            sessionManager.currentClinicVisit = visit
                        }
                        navigateToPaymentView = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 2)
                .padding(.bottom, 140)
            }
            .padding(.horizontal, 2)
        }
        .navigationDestination(isPresented: $navigateToPaymentView) {
            if selectedPaymentOption == "card" {
                PaymentView(
                    onPaymentSuccess: {
                        PaymentStatusView(
                            isSuccess: true,
                            doctor: nil,
                            queue: nil,
                            onContinue: { Queue() },
                            currentVisit: sessionManager.currentClinicVisit
                        )
                    },
                    currentVisit: visitBinding
                )
                .environmentObject(sessionManager)
            } else {
                PaymentThroughCashView {
                    PaymentStatusView(
                        isSuccess: true,
                        doctor: nil,
                        queue: nil,
                        onContinue: { ServicesView() },
                        currentVisit: sessionManager.currentClinicVisit
                    )
                }
                .environmentObject(sessionManager)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LabTestDetailsView(selectedLabCards: [])
            .environmentObject(SessionManagerV2())
    }
}
