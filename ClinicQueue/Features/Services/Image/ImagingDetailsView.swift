//
//  ImagingDetailsView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-11.
//

import SwiftUI

struct ImagingDetailsView: View {
    let selectedTests: [ClinicStep]
    var backgroundColor: Color = AppColors.primary

    @EnvironmentObject var sessionManager: SessionManager
    @State private var selectedPaymentOption: String? = "card"
    @State private var navigateToPaymentView = false

    // Calculate total from all selected imaging tests
    private var totalPrice: Double {
        selectedTests.reduce(0) { $0 + ($1.price ?? 0) }
    }

    private var adminFee: Double {
        PaymentConfig.adminFee
    }

    private var totalPayment: Double {
        totalPrice + adminFee - PaymentConfig.additionalDiscount
    }

    private var paymentDetailsData: [PaymentDetailRow] {
        [
            PaymentDetailRow(label: "Imaging Tests", value: "LKR \(String(format: "%.2f", totalPrice))"),
            PaymentDetailRow(label: "Admin Fee", value: "LKR \(String(format: "%.2f", adminFee))"),
            PaymentDetailRow(label: "Additional Discount", value: "LKR \(String(format: "%.2f", PaymentConfig.additionalDiscount))"),
            PaymentDetailRow(label: "Total", value: "LKR \(String(format: "%.2f", totalPayment))")
        ]
    }

    private let paymentOptionsData: [CheckboxItem] = [
        CheckboxItem(key: "card", label: "Card Payment", icon: Image("Card")),
        CheckboxItem(key: "cash", label: "Cash Payment", icon: Image("Cash"))
    ]

    // Same icon helper as ImageList
    private func icon(for name: String) -> String {
        let lower = name.lowercased()
        if lower.contains("chest") { return "lungs.fill" }
        else if lower.contains("ct scan") || lower.contains("abdomen") { return "cross.case.fill" }
        else if lower.contains("mri brain") { return "brain.head.profile" }
        else if lower.contains("ultrasound") { return "waveform.path.ecg" }
        else if lower.contains("mammography") { return "figure.stand" }
        else if lower.contains("bone") || lower.contains("dxa") { return "staroflife.fill" }
        else if lower.contains("coronary") { return "heart.fill" }
        else if lower.contains("knee") || lower.contains("x-ray") { return "figure.walk" }
        else if lower.contains("spine") || lower.contains("lumbar") { return "person.fill" }
        else if lower.contains("head") || lower.contains("emergency") { return "exclamationmark.triangle.fill" }
        else { return "cross.fill" }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Imaging Tests")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                    }

                    ForEach(Array(selectedTests.enumerated()), id: \.element.id) { index, test in
                        VStack(alignment: .leading, spacing: 16) {

                            // Same card as ImageList
                            BloodTestCard(
                                image: icon(for: test.name),
                                title: test.name,
                                specialText: "Available Now",
                                detailLine1: "Location: \(test.location ?? "")",
                                detailLine2: "Wait: \(test.estimatedWait ?? "")",
                                showExtraSection: false,
                                fee: "LKR \(test.price ?? 0)",
                                onButtonTap: {
                                    print("Fee button tapped for: \(test.name)")
                                },
                                isCheckboxSelectable: false
                            )

                            // Requirements from ClinicStep
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Required:")
                                    .font(.app(.subheading))
                                    .foregroundColor(.primary)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(test.requirements ?? ["No special preparation needed"], id: \.self) { requirement in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•").font(.app(.body))
                                            Text(requirement)
                                                .font(.app(.body))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.leading, 4)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)

                            // Timeline
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Timeline")
                                    .font(.app(.subheading))
                                    .foregroundColor(.primary)

                                Text("We'll recommend the fastest option. You can change if needed.")
                                    .font(.app(.body))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack {
                                    Spacer()
                                    Text("Estimated Time \(test.estimatedWait ?? "~45 min")")
                                        .font(.app(.subheading))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .background(backgroundColor)
                                .cornerRadius(8)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)

                            if index < selectedTests.count - 1 {
                                Divider()
                                    .padding(.vertical, 8)
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
                            // Save totals into session before navigating
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
                    if let currentVisit = sessionManager.currentClinicVisit {
                        PaymentView(
                            onPaymentSuccess: {
                                PaymentStatusView(
                                    isSuccess: true,
                                    doctor: nil,
                                    queue: nil,
                                    onContinue: {
                                        Queue()
                                    },
                                    currentVisit: sessionManager.currentClinicVisit
                                )
                            },
                            currentVisit: Binding(
                                get: { currentVisit },
                                set: { sessionManager.currentClinicVisit = $0 }
                            )
                        )
                    } else {
                        Text("No current visit found")
                    }
                } else {
                    PaymentThroughCashView()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImagingDetailsView(selectedTests: [
            ClinicStep(
                type: .imaging,
                name: "Chest X-Ray (PA & Lateral)",
                description: "A quick, non-invasive imaging test.",
                estimatedWait: "~15 min",
                price: 60,
                location: "Radiology - Level 1, Wing A",
                requirements: ["Remove all jewelry", "Wear loose-fitting clothing"]
            )
        ])
        .environmentObject(SessionManager())
    }
}
