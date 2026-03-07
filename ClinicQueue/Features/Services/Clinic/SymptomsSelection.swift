//
//  SymptomsSelection.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct SymptomsSelection: View {

    private let symptoms: [CheckboxItem] = [
        CheckboxItem(key: "fever", label: "Fever"),
        CheckboxItem(key: "headache", label: "Headache"),
        CheckboxItem(key: "cough", label: "Cough / Cold"),
        CheckboxItem(key: "stomach", label: "Stomach Pain"),
        CheckboxItem(key: "skin", label: "Skin Rash / Allergy"),
        CheckboxItem(key: "body", label: "Body Pain / Joint Pain"),
        CheckboxItem(key: "vomiting", label: "Vomiting / Diarrhea"),
        CheckboxItem(key: "general", label: "General Check-up")
    ]

    @State private var selectedSymptoms: Set<String> = []
    @State private var navigateToAppitmentStarter = false

    var body: some View {

        VStack(spacing: 24) {

            VStack(spacing: 12) {

                Text("Select Your Symptoms")
                    .font(.system(size: 20, weight: .bold))

                Text("Choose the symptoms you’re experiencing. We’ll assign the most suitable available doctor and place you in the queue.")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }

            RoundCheckboxGroup(
                items: symptoms,
                selectedKeys: $selectedSymptoms
            )

            Spacer()

            PrimaryButton(title: "Proceed to Queue") {
                navigateToAppitmentStarter = true
                print("Selected symptoms:", selectedSymptoms)

            }

        }
        .padding(20)
        .navigationDestination(isPresented: $navigateToAppitmentStarter) {
            AppointmentStarterView()
        }
    }
}

#Preview {
    SymptomsSelection()
}
