//
//  ChannelingHistoryView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-11.
//


import SwiftUI

enum ChannelingStatus {
    case completed
    case cancelled
    case upcoming

    var label: String {
        switch self {
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .upcoming:  return "Upcoming"
        }
    }

    var color: Color {
        switch self {
        case .completed: return .green
        case .cancelled: return .red
        case .upcoming:  return .blue
        }
    }
}

struct ChannelingHistory: Identifiable {
    let id = UUID()
    let doctorName: String
    let specialization: String
    let date: String
    let total: String
    let status: ChannelingStatus
}

struct ChannelingHistoryView: View {

    @Environment(\.presentationMode) var presentationMode

    let items: [ChannelingHistory] = [
        ChannelingHistory(
            doctorName: "Dr. Marcus Horizon",
            specialization: "Cardiologist",
            date: "2026/03/10 at 10:00AM",
            total: "$60.00",
            status: .upcoming
        ),
        ChannelingHistory(
            doctorName: "Dr. Sarah Nolan",
            specialization: "Neurologist",
            date: "2026/02/28 at 02:30PM",
            total: "$60.00",
            status: .completed
        ),
        ChannelingHistory(
            doctorName: "Dr. James Perera",
            specialization: "General Physician",
            date: "2026/02/15 at 09:00AM",
            total: "$60.00",
            status: .completed
        ),
        ChannelingHistory(
            doctorName: "Dr. Amara Silva",
            specialization: "Dermatologist",
            date: "2026/02/05 at 11:00AM",
            total: "$160.00",
            status: .cancelled
        ),
        ChannelingHistory(
            doctorName: "Dr. Ravi Fernando",
            specialization: "Orthopedic Surgeon",
            date: "2026/01/20 at 03:00PM",
            total: "$60.00",
            status: .completed
        ),
       
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(items) { item in
                        ChannelingHistoryRow(item: item)
                        Divider()
                            .padding(.horizontal)
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color(white: 0.96))
            .navigationTitle("Channeling History")
            .navigationBarTitleDisplayMode(.inline)
          
        }
    }
}

struct ChannelingHistoryRow: View {
    let item: ChannelingHistory

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.doctorName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)

                    Text(item.specialization)
                        .font(.system(size: 13))
                        .foregroundColor(.blue)

                    Text(item.date)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text("Total: \(item.total)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }

            // Status badge
            Text(item.status.label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(item.status.color)
                .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
    }
}

#Preview {
    ChannelingHistoryView()
}
