//
//  ClinicVisit.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

import Foundation

struct ClinicVisit: Identifiable {

    let id = UUID()


    var patientName: String
    var age: Int
    var gender: String


    var symptomStrings: [String] = []


    var selectedSymptom: Symptom?



    var doctorName: String?
    var specialty: String?


    var queueNumber: String?
    var estimatedWait: String?


    var paymentMethod: String?
    var consultationFee: Double?
    var adminFee: Double?
    var totalPayment: Double {
        (consultationFee ?? 0.0) + (adminFee ?? 0.0) - PaymentConfig.additionalDiscount
    }
    
    var status: String?

}
