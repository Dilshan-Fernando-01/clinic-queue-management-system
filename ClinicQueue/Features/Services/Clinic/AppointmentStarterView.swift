//
//  AppointmentStarterView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct AppointmentStarterView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var assignedDoctor: InfoCardData?
    @State private var selectedQueue: UUID? = nil
    @State private var selectedFloatingDestination: Int? = nil

    
    private var nextAvailableQueue: QueueOption? {
        guard let doctor = assignedDoctor,
              let firstAvailability = doctor.availableDates?.first,
              let queueString = doctor.activeQueueCount else { return nil }

        let currentQueue = Int(queueString.components(separatedBy: " ").first ?? "0") ?? 0
        let nextSlotIndex = currentQueue + 1

        return QueueOption(
            heading: "Slot \(nextSlotIndex)",
            subText: firstAvailability.timeRange
        )
    }
    
    private var queueOptions: [QueueOption] {
        guard let doctor = assignedDoctor,
              let availableDates = doctor.availableDates else { return [] }

        return availableDates.map { availability in
            QueueOption(
                heading: availability.queueLabel,
                subText: availability.timeRange
            )
        }
    }
    
    private var consultationFee: Double {
        guard let priceString = assignedDoctor?.price else { return 0 }

        let cleaned = priceString.replacingOccurrences(of: "$", with: "")
        return Double(cleaned) ?? 0
    }

    private var adminFee: Double {
        PaymentConfig.adminFee
    }

    private var totalPayment: Double {
        consultationFee + adminFee - PaymentConfig.additionalDiscount
    }

    private var paymentDetailsData: [PaymentDetailRow] {
        [
            PaymentDetailRow(label: "Consultation", value: "$\(String(format: "%.2f", consultationFee))"),
            PaymentDetailRow(label: "Admin Fee", value: "$\(String(format: "%.2f", adminFee))"),
            PaymentDetailRow(label: "Additional Discount", value: "$\(String(format: "%.2f", PaymentConfig.additionalDiscount))"),
            PaymentDetailRow(label: "Total", value: "$\(String(format: "%.2f", totalPayment))")
        ]
    }
    
    
    private let paymentOptionsData: [CheckboxItem] = [
        CheckboxItem(
            key: "card",
            label: "Card Payment",
            icon: Image("Card")
        ),
        CheckboxItem(key: "cash", label: "Cash Payment", icon: Image("Cash"))
    ]
    
    @State private var selectedPaymentOption: String? = "card"
    @State private var navigateToPaymentView = false
    
    

    
    var body: some View {
        NavigationStack {
        ZStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Your Clinic Queue")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                      
                    
                    if let doctor = assignedDoctor {

                        let modifiedDoctor = {
                            var d = doctor
                            d.isPriceButtonVisble = false
                            return d
                        }()
                        

                        InfoCard(data: modifiedDoctor)
                            .padding(.horizontal)
                            .padding(.top, Spacing.section)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Queues")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        if let queue = nextAvailableQueue {
                            QueueButtonGroup(
                                queues: [queue],
                                selectedId: $selectedQueue
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                    
                    
                    
                    PaymentDetails(rows: paymentDetailsData)
                        .padding(.horizontal)
                        .padding(.top, Spacing.section)
                    
                    PaymentOptions(
                        items: paymentOptionsData,
                        selectedKey: $selectedPaymentOption
                    )
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                    
                    PrimaryButton(title: "Book Appointment") {
                        navigateToPaymentView = true
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.section)
                }
                .padding(.vertical, 20)
                .onAppear {
                    if let symptom = sessionManager.currentClinicVisit?.selectedSymptom {
                        let filteredDoctors = DoctorData.doctorGroups
                            .first(where: { $0.specialty == symptom.specialty })?
                            .doctors ?? []
                        assignedDoctor = DoctorData.leastBusyDoctor(from: filteredDoctors)
                    } else {
                        let generalDoctors = DoctorData.doctorGroups
                            .first(where: { $0.specialty == "General" })?
                            .doctors ?? []
                        assignedDoctor = DoctorData.leastBusyDoctor(from: generalDoctors)
                    }
                    
                   
                    selectedQueue = nextAvailableQueue?.id


                    if var visit = sessionManager.currentClinicVisit, let doctor = assignedDoctor {

                        let cleanedPrice = doctor.price?.replacingOccurrences(of: "$", with: "") ?? "0"
                        visit.consultationFee = Double(cleanedPrice) ?? 0
                        visit.adminFee = PaymentConfig.adminFee
                        sessionManager.currentClinicVisit = visit
                    }
                }
                .navigationDestination(isPresented: $navigateToPaymentView) {
                    if selectedPaymentOption == "card" {
                        if let currentVisit = sessionManager.currentClinicVisit {
                            PaymentView(
                                onPaymentSuccess: {
                                    PaymentStatusView(
                                        isSuccess: true,
                                        doctor: assignedDoctor,
                                        queue: nextAvailableQueue,
                                        onContinue: {
                                            QueueStageWaitingView()
                                        },
                                        currentVisit: sessionManager.currentClinicVisit
                                    )
                                }, currentVisit: Binding(
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
            
                FloatingNav(
                    mainIcon: "plus",
                    items: [
                        FloatingNavItem(icon: "house.fill", label: "Home", destination: AnyView(ServicesView())),
                        FloatingNavItem(icon: "map.fill", label: "Map", destination: AnyView(Text("Map View"))),
                        FloatingNavItem(icon: "gearshape.fill", label: "Settings", destination: AnyView(SettingsView()))
                    ]
                )
           
   
        }
        
        
    }
    
    }
    
}

#Preview {
    AppointmentStarterView()
}
