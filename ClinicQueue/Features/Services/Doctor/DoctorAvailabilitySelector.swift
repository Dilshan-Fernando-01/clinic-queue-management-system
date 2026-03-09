//
//  DoctorAvailabilitySelector.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

import SwiftUI

struct DoctorAvailabilitySelector: View {

    let items: [DoctorAvailability]

    @Binding var selectedId: String?

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Available Date")
                .font(.system(size: 20, weight: .bold))

            ForEach(items) { item in

                RadioOptionRow(
                    id: item.id.uuidString,
                    title: item.weekday,
                    subtitle: item.timeRange,
                    icon: item.icon,
                    selectedId: $selectedId
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



