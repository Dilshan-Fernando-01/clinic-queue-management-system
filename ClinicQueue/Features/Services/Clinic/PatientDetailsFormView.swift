//
//  PatientDetailsFormView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

extension PatientDetailsFormView {
    


    var isFormValid: Bool {
        isNameValid && isAgeValid && gender != nil
    }

    var isNameValid: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }

        let hasNumber = name.rangeOfCharacter(from: .decimalDigits) != nil
        return !hasNumber
    }

    var isAgeValid: Bool {
        guard let ageInt = Int(age) else { return false }
        return ageInt > 0 && ageInt < 150
    }

}



struct PatientDetailsFormView: View {

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var gender: String? = nil
    @State private var navigateToSymptoms = false

    private let genderOptions: [DropdownOption] = [
        DropdownOption(key: "male", label: "Male"),
        DropdownOption(key: "female", label: "Female"),
        DropdownOption(key: "other", label: "Other")
    ]

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 8) {

                    Text("Confirm Your Details")
                        .font(.system(size: 20, weight: .bold))

                    Text("Please verify your information before joining the consultation queue.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 16) {

                    InputField(
                        placeholder: "Patient Name",
                        value: $name
                    )

                    InputField(
                        placeholder: "Age",
                        value: $age
                    )

                    CustomDropdown(
                        placeholder: "Gender",
                        options: genderOptions,
                        selectedKey: $gender
                    )
                }

                Spacer()

                PrimaryButton(title: "Proceed to Queue") {

                    navigateToSymptoms = true

                }
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1 : 0.5)

            }
            .padding(.horizontal)
            .padding(.top, 20)

            .navigationDestination(isPresented: $navigateToSymptoms) {
                SymptomsSelection()
            }

        }
    }
}
