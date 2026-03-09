
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
    @State private var selectedTestIndex = 0
    @State private var navigateToNext = false
    private let paymentDetailsData: [PaymentDetailRow] = [
        PaymentDetailRow(label: "Consultation", value: "$59.00"),
        PaymentDetailRow(label: "Admin Fee", value: "$01.00"),
        PaymentDetailRow(label: "Additional Discount", value: "-"),
        PaymentDetailRow(label: "Total", value: "$70.00")
    ]
    private let paymentOptionsData: [CheckboxItem] = [
        CheckboxItem(
            key: "card",
            label: "Card Payment",
            icon: Image("Card")
        ),
        CheckboxItem(key: "cash", label: "Cash Payment", icon: Image("Cash"))
    ]
    @State private var navigateToPaymentView = false
    @State private var selectedPaymentOption: String? = "card"
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(Array(selectedTests.enumerated()), id: \.element.id) { index, test in
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text(test.title)
                                .font(.app(.heading))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, index == 0 ? 6 : 2)
                            
                         
                            SelectableLabCard(
                                props: test,
                                isSelected: true,
                                onTap: {},
                                onButtonTap: {
                                    print("Fee button tapped for: \(test.title)")
                                }
                            )
                            
                            // Required Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Required:")
                                    .font(.app(.subheading))
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .font(.app(.body))
                                        Text("No special preparation needed")
                                            .font(.app(.body))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .font(.app(.body))
                                        Text("Bring your lab request form")
                                            .font(.app(.body))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.leading, 4)
                            }
                            .padding(.vertical, 8)
                            
                            // Timeline Section
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
                                    Text("Estimated Time ~ 45 min")
                                        .font(.app(.subheading))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .background(backgroundColor)
                                .cornerRadius(8)
                            }
                            .padding(.vertical, 8)
                            
                            if index < selectedTests.count - 1 {
                                Divider()
                                    .padding(.vertical, 8)
                            }
                        }
                    }
                    
                    PaymentDetails(rows: paymentDetailsData)
                        .padding(.top, Spacing.section)
                    
                    PaymentOptions(
                        items: paymentOptionsData,
                        selectedKey: $selectedPaymentOption
                    )
                    
                    .padding(.top, Spacing.section)

                    HStack {
                        PrimaryButton(title: "Booking", maxWidth: 220) {
                            print("Continue to next step")
                            navigateToNext = true
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    .navigationDestination(isPresented: $navigateToPaymentView) {
                        if selectedPaymentOption == "card" {
                            PaymentView {
                                PaymentStatusView(
                                    isSuccess: true,
                                    onContinue: {
                                        QueueStageWaitingView()
                                    }
                                )
                            }
                        } else {
                            PaymentThroughCashView()
                        }
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 20)
            }
        }
        .safeAreaInset(edge: .top) {
            HeaderSection(title: "Lab Test Details")
        }
        .navigationDestination(isPresented: $navigateToNext) {
            Text("Next View")
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
                buttonText: "Fee $25"
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
                buttonText: "Fee $25"
            )
        ])
    }
}
