//
//  Queue.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-10.
//

import SwiftUI

struct Queue: View {

    @EnvironmentObject var sessionManager: SessionManager
    @State private var simulatedStatus: StepStatus = .waiting

    
    private var doctorStep: ClinicStep? {
        sessionManager.currentClinicVisit?.doctorStep
    }

    private var doctorInfo: InfoCardData? {
        guard let step = doctorStep else { return nil }
        return InfoCardData(
            image: step.serviceImage ?? Image("DoctorPlaceholder"),
            heading: step.name,
            subheading: step.specialty ?? "",
            activeQueueCount: nil,
            detail1: ("Location:", step.location ?? "N/A"),
            detail2: nil,
            price: step.price != nil ? "$\(Int(step.price!))" : "Free",
            availableDates: nil,
            maxPatientsPerDay: nil,
            isPriceButtonVisble: step.price != nil
        )
    }

    private func mapQueueStage(for status: StepStatus) -> QueueStage {
        switch status {
        case .pending, .waiting: return .wait
        case .next: return .next
        case .ready: return .ready
        case .inProgress: return .inProgress
        case .completed: return .completed
        }
    }

 
    private func startQueueSimulation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { simulatedStatus = .next }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { simulatedStatus = .ready }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { simulatedStatus = .inProgress }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) { simulatedStatus = .completed }
    }


    private var requestedTests: [ClinicStep] {
        guard let visit = sessionManager.currentClinicVisit else { return [] }
        var tests: [ClinicStep] = []

       
        for symptomKey in visit.symptomStrings {
            let recommended = TestRecommendation.recommendedTests(for: symptomKey)
            tests.append(contentsOf: recommended)
        }

      
        var uniqueTests: [ClinicStep] = []
        for test in tests {
            if !uniqueTests.contains(where: { $0.id == test.id }) {
                uniqueTests.append(test)
            }
        }

        print("DEBUG: Requested tests for current visit:")
        for t in uniqueTests { print("- \(t.name)") }

        return uniqueTests
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

             
                if let visit = sessionManager.currentClinicVisit,
                   let doctorStep = visit.doctorStep {
                    QueueBanner(
                        queueNumber: doctorStep.queueNumber ?? "--",
                        queueStage: mapQueueStage(for: simulatedStatus),
                        nowServingNumber: doctorStep.queueNumber ?? "--",
                        estimatedWait: "~15 minutes"
                    )
                }

               
                if let doctor = doctorInfo {
                    VStack(spacing: 16) {
                        Text("Currently Serving")
                            .font(.system(size: 22, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        InfoCard(data: doctor)
                            .padding(.horizontal, 20)
                    }
                }

              
                if simulatedStatus == .completed && !requestedTests.isEmpty {
                    VStack(spacing: 16) {
                        Text("Doctor-Requested Services")
                            .font(.system(size: 22, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        ForEach(requestedTests) { step in
                            BloodTestCard(
                                image: step.serviceImage != nil ? "doctor01" : "Placeholder",
                                title: step.name,
                                specialText: step.specialty ?? "",
                                detailLine1: "Location: \(step.location ?? "N/A")",
                                detailLine2: step.estimatedWait ?? "",
                                showExtraSection: false,
                                fee: step.price != nil ? "$\(Int(step.price!))" : "Free"
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                }

            }
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
        .background(Color(white: 0.95))
        .onAppear {
            startQueueSimulation()
        }
    }
}

#Preview {
    Queue()
}
