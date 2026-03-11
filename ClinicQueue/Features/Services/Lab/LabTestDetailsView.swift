//
//  LabTestDetailsView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-08.
//

import SwiftUI

struct LabTestDetailsView: View {
    let selectedTests: [LabCardData]
    var backgroundColor: Color = AppColors.primary

    @State private var navigateToPaymentView = false
    @State private var selectedPaymentOption: String? = "card"
    @EnvironmentObject var sessionManager: SessionManager

    private var adminFee: Double {
        PaymentConfig.adminFee
    }

    private var totalPrice: Double {
        selectedTests.reduce(0.0) { sum, test in
            let cleaned = test.buttonText.replacingOccurrences(of: "$", with: "")
            return sum + (Double(cleaned) ?? 0.0)
        }
    }
    private var totalPayment: Double {
        totalPrice + adminFee - PaymentConfig.additionalDiscount
    }

    // ✅ Dynamic payment details from actual selected tests
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
            get: { sessionManager.currentClinicVisit ?? ClinicVisit(patientName: "", age: 0, gender: "") },
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

                ForEach(Array(selectedTests.enumerated()), id: \.element.id) { index, test in
                    VStack(alignment: .leading, spacing: 16) {

                        // ✅ Same card style as TestHistoryView / ImagingDetailsView
                        BloodTestCard(
                            image: test.icon,
                            title: test.title,
                            specialText: test.description1,
                            detailLine1: "\(test.label1)\(test.label1Text)",
                            detailLine2: "",
                            showExtraSection: true,
                            bottomTitleLeft: "Requirements",
                            listItems: ["No special preparation needed", "Bring your lab request form"],
                            bottomTitleRight: "Approx Time",
                            bottomSubTextRight: test.label1Text,
                            fee: test.buttonText,
                            isActiveQueue: true
                        )

                        if index < selectedTests.count - 1 {
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
                        // ✅ Save totals into session before navigating
                        if var visit = sessionManager.currentClinicVisit {
                            visit.consultationFee = totalPrice
                            visit.adminFee        = adminFee
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

        // ✅ Card → PaymentView → PaymentStatusView → Queue
        .navigationDestination(isPresented: $navigateToPaymentView) {
            if selectedPaymentOption == "card" {
                PaymentView(
                    onPaymentSuccess: {
                        PaymentStatusView(
                            isSuccess: true,
                            doctor: nil,
                            queue: nil,
                            onContinue: { Queue() },   // ✅ Queue after success
                            currentVisit: sessionManager.currentClinicVisit
                        )
                    },
                    currentVisit: visitBinding
                )
                .environmentObject(sessionManager)
            } else {
                PaymentThroughCashView()
                    .environmentObject(sessionManager)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LabTestDetailsView(selectedTests: [
            LabCardData(
                icon: "SearchIcon",
                iconSize: 32,
                title: "Complete Blood Count (CBC)",
                description1: "12 patients in queue",
                label1: "Estimated wait: ",
                label1Text: "~45 min",
                label2: "Location: ",
                label2Text: "Room 02 - Consultation Wing",
                buttonText: "$25"
            ),
            LabCardData(
                icon: "SearchIcon",
                iconSize: 32,
                title: "ESR",
                description1: "12 patients in queue",
                label1: "Estimated wait: ",
                label1Text: "~45 min",
                label2: "Location: ",
                label2Text: "Room 02 - Consultation Wing",
                buttonText: "$25"
            )
        ])
        .environmentObject(SessionManager())
    }
}
