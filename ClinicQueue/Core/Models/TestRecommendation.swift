//
//  TestRecommendation.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-10.
//

import Foundation

struct TestRecommendation {
    
    static func recommendedTests(for symptomKey: String) -> [ClinicStep] {
        var recommended: [ClinicStep] = []

        switch symptomKey.lowercased() {
        case "eye":
            if let cbc = LabData.labTest.first(where: { $0.name.contains("CBC") }) {
                recommended.append(cbc)
            }
            if let mri = ImagingData.imagingTests.first(where: { $0.name.contains("MRI Brain") }) {
                recommended.append(mri)
            }
            
        case "chest":
            if let lipid = LabData.labTest.first(where: { $0.name.contains("Lipid") }) {
                recommended.append(lipid)
            }
            if let xray = ImagingData.imagingTests.first(where: { $0.name.contains("Chest X-Ray") }) {
                recommended.append(xray)
            }
            
        case "fever":
            if let cbc = LabData.labTest.first(where: { $0.name.contains("CBC") }) {
                recommended.append(cbc)
            }
        case "stomach":
            if let lft = LabData.labTest.first(where: { $0.name.contains("Liver") }) {
                recommended.append(lft)
            }
            if let abdUltrasound = ImagingData.imagingTests.first(where: { $0.name.contains("Abdomen") }) {
                recommended.append(abdUltrasound)
            }
            
        default:
            break
        }

        return recommended
    }
}
