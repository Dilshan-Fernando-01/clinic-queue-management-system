//
//  DoctorData.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//


import SwiftUI

struct DoctorCategoryGroup {
    let specialty: String
    let doctors: [InfoCardData]
}


struct DoctorData {

    static let doctorGroups: [DoctorCategoryGroup] = [

        DoctorCategoryGroup(
            specialty: "Cardiology",
            doctors: [
                InfoCardData(
                    image: Image("doctor01"),
                    heading: "Dr. Jane Doe",
                    subheading: "Cardiologist",
                    activeQueueCount: "12 patients in queue",
                    detail1: ("Estimated wait:", "~25 min"),
                    detail2: ("Location:", "Room 02"),
                    price: "$25",
                    availableDates: generateDates(days: 10),
                    maxPatientsPerDay: 20
                ),
                InfoCardData(
                    image: Image("doctor02"),
                    heading: "Dr. Robert King",
                    subheading: "Cardiologist",
                    activeQueueCount: "6 patients in queue",
                    detail1: ("Estimated wait:", "~10 min"),
                    detail2: ("Location:", "Room 04"),
                    price: "$40",
                    availableDates: generateDates(days: 5),
                    maxPatientsPerDay: 15
                )
            ]
        ),

        DoctorCategoryGroup(
            specialty: "Dermatology",
            doctors: [
                InfoCardData(
                    image: Image("doctor03"),
                    heading: "Dr. Alex Smith",
                    subheading: "Dermatologist",
                    activeQueueCount: "8 patients in queue",
                    detail1: ("Estimated wait:", "~15 min"),
                    detail2: ("Location:", "Room 05"),
                    price: "$50",
                    availableDates: generateDates(days: 7),
                    maxPatientsPerDay: 12
                ),
                InfoCardData(
                    image: Image("doctor04"),
                    heading: "Dr. Sarah Lee",
                    subheading: "Dermatologist & Cosmetic Specialist",
                    activeQueueCount: "5 patients in queue",
                    detail1: ("Estimated wait:", "~20 min"),
                    detail2: ("Location:", "Room 06"),
                    price: "$60",
                    availableDates: generateDates(days: 10),
                    maxPatientsPerDay: 10
                )
            ]
        ),

        DoctorCategoryGroup(
            specialty: "Pediatrics",
            doctors: [
                InfoCardData(
                    image: Image("doctor05"),
                    heading: "Dr. Peter Pan",
                    subheading: "Pediatrician",
                    activeQueueCount: "4 patients in queue",
                    detail1: ("Estimated wait:", "~5 min"),
                    detail2: ("Location:", "Room 07"),
                    price: "$30",
                    availableDates: generateDates(days: 8),
                    maxPatientsPerDay: 25
                )
            ]
        ),

        DoctorCategoryGroup(
            specialty: "Neurology",
            doctors: [
                InfoCardData(
                    image: Image("doctor06"),
                    heading: "Dr. Emily Clark",
                    subheading: "Neurologist",
                    activeQueueCount: "3 patients in queue",
                    detail1: ("Estimated wait:", "~10 min"),
                    detail2: ("Location:", "Room 08"),
                    price: "$70",
                    availableDates: generateDates(days: 6),
                    maxPatientsPerDay: 12
                )
            ]
        ),

        DoctorCategoryGroup(
            specialty: "Orthopedics",
            doctors: [
                InfoCardData(
                    image: Image("doctor07"),
                    heading: "Dr. Michael Brown",
                    subheading: "Orthopedic Surgeon",
                    activeQueueCount: "9 patients in queue",
                    detail1: ("Estimated wait:", "~30 min"),
                    detail2: ("Location:", "Room 09"),
                    price: "$80",
                    availableDates: generateDates(days: 12),
                    maxPatientsPerDay: 18
                )
            ]
        )


    ]
}

func generateDates(days: Int) -> [DoctorAvailability] {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE" 

    var items: [DoctorAvailability] = []
    let today = Date()

    for i in 0..<days {
        if let date = calendar.date(byAdding: .day, value: i, to: today) {
            let weekday = formatter.string(from: date)
            let timeRange = "17:30 pm - 20:30 pm"
            let icon = Image(systemName: "calendar")
            let queueLabel = "Slot \(i + 1)"

            items.append(
                DoctorAvailability(
                    weekday: weekday,
                    timeRange: timeRange,
                    icon: icon,
                    queueLabel: queueLabel,
                    date: date
                )
            )
        }
    }

    return items
}
