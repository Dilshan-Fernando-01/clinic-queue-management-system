//
//  Queue.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-10.
//

extension QueueStage {
    func toQueueStages() -> QueueStages {
        switch self {
        case .wait: return .wait
        case .next: return .next
        case .ready: return .ready
        case .inProgress: return .inProgress
        case .completed: return .completed
        }
    }
}


import SwiftUI


struct Queue: View {

    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var session: SessionManagerV2
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
    
    
    
    private func updateActiveActivityQueue() {

        if let selectedIndex = session.activities.firstIndex(where: { $0.isSelected && $0.service == session.currentService }) {
            let newQueueStage = mapQueueStage(for: simulatedStatus).toQueueStages()
            session.activities[selectedIndex].queueStage = newQueueStage
            print("Updated queueStage for active activity: \(session.activities[selectedIndex].id) -> \(newQueueStage)")
        } else {
            print("No active activity found for current service")
        }
    }
    

 
    private func startQueueSimulation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            simulatedStatus = .next
            updateActiveActivityQueue()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            simulatedStatus = .ready
            updateActiveActivityQueue()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            simulatedStatus = .inProgress
            updateActiveActivityQueue()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            simulatedStatus = .completed
            updateActiveActivityQueue()
        }
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
                
                
                if simulatedStatus == .completed && !requestedTests.isEmpty {
                    VStack(spacing: 16) {
                        Text("Requested Services")
                            .font(.system(size: 22, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 33)

                        ForEach(requestedTests) { step in
                            BloodTestCard(
                                image: "doctor01",
                                title: step.name,
                                specialText:  "",
                                detailLine1: "Location: \(step.location ?? "N/A")",
                                detailLine2: "",
                                
                                showExtraSection: true,
                                
                                bottomTitleLeft: "Requirements",
                                listItems: step.requirements ?? [],
                                
                                bottomTitleRight: "Approximate Time",
                                bottomSubTextRight: step.estimatedWait ?? "",
                                
                                fee: step.price != nil ? "$\(Int(step.price!))" : "Free",
                                
                                isActiveQueue: true
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                }

               
                if let doctor = doctorInfo {
                    VStack(spacing: 16) {
                        Text("Services")
                            .font(.system(size: 22, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        InfoCard(data: doctor)
                            .padding(.horizontal, 15)
                    }.padding(.horizontal, 18)
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
