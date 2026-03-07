//
//  QueueButtonGroup.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct QueueOption: Identifiable {
    let id = UUID()
    let heading: String
    let subText: String
}

struct QueueButtonGroup: View {
    let queues: [QueueOption]
    @Binding var selectedId: UUID?

    var body: some View {
        HStack(spacing: 10) {
            ForEach(queues) { queue in
                let isSelected = selectedId == queue.id

                Button {
                    selectedId = queue.id
                } label: {
                    VStack(spacing: 6) {
                        Text(queue.heading)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(isSelected ? .white : .black)

                        Text(queue.subText)
                            .font(.system(size: 8))
                            .foregroundColor(isSelected ? .white : AppColors.text)
                    }
                    .frame(minWidth: 96, minHeight: 76)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? AppColors.primary : .white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isSelected ? Color(hex: "157979") : Color(hex: "ECF5F5"),
                                lineWidth: 2
                            )
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: queues.count == 1 ? .center : .leading)
        .onAppear {
            if queues.count == 1 {
                selectedId = queues.first?.id
            }
        }
    }
}
