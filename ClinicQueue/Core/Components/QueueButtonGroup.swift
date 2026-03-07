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
        HStack(spacing: 12) {
            ForEach(queues) { queue in
                let isSelected = selectedId == queue.id
                let bgColor = isSelected ? Color("169A8F") : Color.white
                let textColor = isSelected ? Color.white : Color("000000")
                let subTextColor = isSelected ? Color.white : Color("9E9E9E")
                let borderColor = isSelected ? Color("157979") : Color("ECF5F5")
                
                Button(action: {
                    selectedId = queue.id
                }) {
                    VStack(spacing: 8) {
                        Text(queue.heading)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(textColor)
                        Text(queue.subText)
                            .font(.system(size: 12))
                            .foregroundColor(subTextColor)
                    }
                    .frame(width: 96)
                    .frame(minHeight: 76)
                    .background(bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(borderColor, lineWidth: 2)
                    )
                    .cornerRadius(10)
                }
            }
        }
    }
}
