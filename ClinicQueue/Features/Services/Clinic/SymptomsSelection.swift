//
//  SymptomsSelection.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct SymptomsSelection: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var session: SessionManagerV2

    private let symptoms: [CheckboxItem] = SymptomData.symptoms.map {
        CheckboxItem(key: $0.key, label: $0.label)
    }

    @State private var selectedSymptoms: Set<String> = []
    @State private var navigateToAppitmentStarter = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
 
                    VStack(spacing: 12) {
                        Text("Select Your Symptoms")
                            .font(.system(size: 20, weight: .bold))

                        Text("Choose the symptoms you’re experiencing. We’ll assign the most suitable available doctor and place you in the queue.")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)

                   
                    RoundCheckboxGroup(
                        items: symptoms,
                        selectedKeys: $selectedSymptoms
                    )
                }
                .padding(20)
            }


            VStack {
                PrimaryButton(title: "Proceed to Queue") {
                    let selectedKeysArray = Array(selectedSymptoms)
                    if let firstSymptomKey = selectedKeysArray.first,
                       let symptomObj = SymptomData.symptoms.first(where: { $0.key == firstSymptomKey }) {
                        sessionManager.currentClinicVisit?.selectedSymptom = symptomObj
                    }
                    //**
                    if session.activity(for: .clinic) == nil {
                          session.addActivity(service: .clinic)
                      }
                    sessionManager.currentClinicVisit?.symptomStrings = selectedKeysArray
                    if let activeActivityIndex = session.activities.firstIndex(where: { $0.isSelected }) {
                        session.activities[activeActivityIndex].symptoms = selectedKeysArray
                        session.activities = session.activities
                        session.printAllActivities() 
                    }
                    navigateToAppitmentStarter = true
                }
                .disabled(selectedSymptoms.isEmpty)
            }
            .padding(20)
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5) 
        }
        .navigationDestination(isPresented: $navigateToAppitmentStarter) {
            AppointmentStarterView().environmentObject(sessionManager)
        }
    }
}
#Preview {
    SymptomsSelection()
}
