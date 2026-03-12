//
//  LabTestDetailsView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

// Workaround wrapper to hold image without changing ClinicStep
struct LabStepDisplay {
    let step: ClinicStep
    let testImageName: String
}

struct LabTestDetailsView: View {
    @EnvironmentObject var sessionManager: SessionManagerV2

    var backgroundColor: Color = AppColors.primary
    @State private var navigateToPaymentView = false
    @State private var selectedPaymentOption: String? = "card"

    private var adminFee: Double {
        PaymentConfig.adminFee
    }

    private var labStepsDisplay: [LabStepDisplay] {
        sessionManager.activities
            .filter { $0.service == .lab }
            .compactMap { activity -> LabStepDisplay? in
                guard let labStep = activity.labStep else { return nil }
                // Assign default image name or customize per test
                return LabStepDisplay(step: labStep, testImageName: "SearchIcon")
            }
    }

    private var totalPrice: Double {
        labStepsDisplay.reduce(0.0) { sum, display in
            sum + (display.step.price ?? 0)
        }
    }

    private var totalPayment: Double {
        totalPrice + adminFee - PaymentConfig.additionalDiscount
    }

    private var paymentDetailsData: [PaymentDetailRow] {
        [
            PaymentDetailRow(label: "Lab Tests", value: "$ \(String(format: "%.2f", totalPrice))"),
            PaymentDetailRow(label: "Admin Fee", value: "$ \(String(format: "%.2f", adminFee))"),
            PaymentDetailRow(label: "Additional Discount", value: "$ \(String(format: "%.2f", PaymentConfig.additionalDiscount))"),
            PaymentDetailRow(label: "Total", value: "$ \(String(format: "%.2f", totalPayment))")
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

                // Display LabStepDisplay
                ForEach(Array(labStepsDisplay.enumerated()), id: \.element.step.id) { index, display in
                    VStack(alignment: .leading, spacing: 16) {

                      
                        BloodTestCard(
                            image: TestDataset.imageName(for: display.step.name),
                            title: display.step.name,
                            specialText: "Lab Test",
                            detailLine1: "Estimated wait: \(display.step.estimatedWait ?? "-")",
                            detailLine2: display.step.location ?? "",
                            showExtraSection: true,
                            bottomTitleLeft: "Requirements",
                            listItems: ["No special preparation needed", "Bring your lab request form"],
                            bottomTitleRight: "Approx Time",
                            bottomSubTextRight: display.step.estimatedWait ?? "-",
                            fee: "$\(String(format: "%.2f", display.step.price ?? 0))",
                            isActiveQueue: false
                        )

                        if index < labStepsDisplay.count - 1 {
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
                          onContinue: { Queue() },
                          currentVisit: sessionManager.currentClinicVisit
                      )
                  }.environmentObject(sessionManager)
                    
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        LabTestDetailsView(selectedTests: [])
//            .environmentObject(SessionManagerV2())
//    }
//}
