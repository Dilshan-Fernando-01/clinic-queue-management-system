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

    // MARK: - Doctor Step
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

   
    private var completedSteps: [ClinicStep] {
        guard let steps = sessionManager.currentClinicVisit?.steps else { return [] }
        return steps.filter { $0.isFinished && $0.type != .doctor }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

             
                if let visit = sessionManager.currentClinicVisit,
                   let doctorStep = visit.doctorStep {
                    QueueBanner(
                        queueNumber: doctorStep.queueNumber ?? "--",
                        queueStage: mapQueueStage(for: simulatedStatus),
                        nowServingNumber: doctorStep.queueNumber ?? "--",
                        estimatedWait: "~15 minutes"
                    )
                  
                }

                
                if let doctor = doctorInfo,
                   simulatedStatus != .completed {
                    VStack(spacing: 12) {
                        Text("Currently Serving")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        InfoCard(data: doctor)
                            .padding(.horizontal, 20)
                    }
                }

               
                if simulatedStatus == .completed && !completedSteps.isEmpty {
                    VStack(spacing: 12) {
                        Text("Completed / Requested Services")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        ForEach(completedSteps) { step in
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
            .padding(.top, 0)
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
