//
//  DummyAppointmentData.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-12.
//

import SwiftUI

struct DummyAppointments {
    
    static func generate() -> [UpcomingAppointment] {
        var appointments: [UpcomingAppointment] = []
        
        let allDoctors = DoctorData.doctorGroups.flatMap { $0.doctors }
        

        if let todayDoctor = allDoctors.first {
            let labTests = LabData.labTests.prefix(2)
            let imagingTests = ImagingData.imagingTests.prefix(1)
            
            var activities: [Activity] = []
            
            for test in labTests {
                activities.append(
                    Activity(
                        service: .lab,
                        stage: .planning,
                        selectedDoctor: todayDoctor,
                        isSelected: true,
                        queueStage: .wait,
                        labStep: LabData.labTest.first(where: { $0.name == test.title }) ?? nil,
                        testName: test.title
                    )
                )
            }
            
            for test in imagingTests {
                activities.append(
                    Activity(
                        service: .imaging,
                        stage: .planning,
                        selectedDoctor: todayDoctor,
                        isSelected: true,
                        queueStage: .wait,
                        imagingStep: ImagingData.imagingTests.first(where: { $0.name == test.name }) ?? nil,
                        testName: test.name
                    )
                )
            }
            
            let appointment = UpcomingAppointment(
                id: UUID(),
                date: Date(),
                patientName: "John Doe",
                age: 32,
                gender: "Male",
                activities: activities,
                totalFee: 50
            )
            
            appointments.append(appointment)
        }
        

        for i in 1...2 {
            if let doctor = allDoctors[safe: i+1] {
                let activity = Activity(
                    service: .appointment,
                    stage: .planning,
                    selectedDoctor: doctor,
                    isSelected: false,
                    queueStage: .wait
                )
                
                let appointment = UpcomingAppointment(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date(),
                    patientName: "Patient \(i+1)",
                    age: 25 + i,
                    gender: i % 2 == 0 ? "Female" : "Male",
                    activities: [activity],
                    totalFee: 50
                )
                
                appointments.append(appointment)
            }
        }
        
        for i in 3...4 {
            if let doctor = allDoctors[safe: i+2] {
                let activity = Activity(
                    service: .appointment,
                    stage: .completed,
                    selectedDoctor: doctor,
                    isSelected: false,
                    queueStage: .completed
                )
                
                let appointment = UpcomingAppointment(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date(),
                    patientName: "Patient \(i+1)",
                    age: 28 + i,
                    gender: i % 2 == 0 ? "Female" : "Male",
                    activities: [activity],
                    totalFee: 50
                )
                
                appointments.append(appointment)
            }
        }
        
        return appointments
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
