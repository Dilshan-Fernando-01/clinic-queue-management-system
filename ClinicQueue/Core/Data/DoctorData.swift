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
                    price: "$25"
                ),
                InfoCardData(
                    image: Image("doctor01"),
                    heading: "Dr. Robert King",
                    subheading: "Cardiologist",
                    activeQueueCount: "6 patients in queue",
                    detail1: ("Estimated wait:", "~10 min"),
                    detail2: ("Location:", "Room 04"),
                    price: "$40"
                )
            ]
        ),

        DoctorCategoryGroup(
            specialty: "Dermatology",
            doctors: [
                InfoCardData(
                    image: Image("doctor01"),
                    heading: "Dr. Alex Smith",
                    subheading: "Dermatologist",
                    activeQueueCount: "8 patients in queue",
                    detail1: ("Estimated wait:", "~15 min"),
                    detail2: ("Location:", "Room 05"),
                    price: "$50"
                )
            ]
        )

    ]
}
