//
//  ClinicStep.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

import Foundation

enum StepType {
    case doctor
    case labTest
    case imaging
}

enum StepStatus: String {
    case pending
    case waiting
    case inProgress
    case completed
}

struct ClinicStep: Identifiable {
    let id = UUID()
    
    var type: StepType
    var name: String
    var description: String?        
    var estimatedWait: String?
    var price: Double?
    var location: String?
    var requirements: [String]?
    var specialty: String?
    var queueNumber: String?
    var status: StepStatus = .pending
}
