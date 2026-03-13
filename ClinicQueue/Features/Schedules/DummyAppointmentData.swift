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
        
        print("===== DUMMY APPOINTMENT GENERATION START =====")
        

        
        if let todayDoctor = allDoctors.first {
            
            let labTests = LabData.labTests.prefix(2)
            let imagingTests = ImagingData.imagingTests.prefix(1)
            
            var activities: [Activity] = []
            

            activities.append(
                Activity(
                    service: .appointment,
                    stage: .planning,
                    selectedDoctor: todayDoctor,
                    isSelected: true,
                    queueStage: .wait
                )
            )
            
            print("Added Doctor Activity:", todayDoctor.heading ?? "Doctor")
            

            for test in labTests {
                let labStep = LabData.labTest.first(where: { $0.name == test.title })
                
                activities.append(
                    Activity(
                        service: .appointment,
                        stage: .planning,
                        selectedDoctor: nil,
                        isSelected: false,
                        queueStage: .unknown,
                        labStep: labStep,
                        testName: test.title
                    )
                )
                
                print("Added Lab Activity:", test.title)
            }
            
            for test in imagingTests {
                let imagingStep = ImagingData.imagingTests.first(where: { $0.name == test.name })
                
                activities.append(
                    Activity(
                        service: .appointment,
                        stage: .planning,
                        selectedDoctor: nil,
                        isSelected: false,
                        queueStage: .unknown,
                        imagingStep: imagingStep,
                        testName: test.name
                    )
                )
                
                print("Added Imaging Activity:", test.name)
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
            
            print("Today's appointment created with \(activities.count) activities")
        }
        
        
   
        
        for i in 1...2 {
            if let doctor = allDoctors[safe: i + 1] {
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
                    patientName: "Patient \(i + 1)",
                    age: 25 + i,
                    gender: i % 2 == 0 ? "Female" : "Male",
                    activities: [activity],
                    totalFee: 50
                )
                
                appointments.append(appointment)
                print("Future appointment created for:", doctor.heading ?? "Doctor")
            }
        }
        
        
        
        for i in 3...4 {
            if let doctor = allDoctors[safe: i + 2] {
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
                    patientName: "Patient \(i + 1)",
                    age: 28 + i,
                    gender: i % 2 == 0 ? "Female" : "Male",
                    activities: [activity],
                    totalFee: 50
                )
                
                appointments.append(appointment)
                print("Completed appointment created for:", doctor.heading ?? "Doctor")
            }
        }
        
        
        print("===== FINAL APPOINTMENT STRUCTURE =====")
        for appointment in appointments {
            print("Patient:", appointment.patientName)
            for (index, activity) in appointment.activities.enumerated() {
                print(
                    "Activity \(index + 1):",
                    "Service:", activity.service,
                    "| TestName:", activity.testName ?? "Doctor",
                    "| Selected:", activity.isSelected,
                    "| QueueStage:", activity.queueStage,
                    "| Doctor:", activity.selectedDoctor?.heading ?? "None"
                )
            }
            print("-----------------------------")
        }
        print("===== DUMMY APPOINTMENT GENERATION END =====")
        
        return appointments
    }
}



extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
