//
//  FindLabView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-06.
//

import SwiftUI

struct FindLabView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.green)
                        TextField("Find Lab", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    
                    // Category Chips
                    HStack(spacing: 12) {
                        categoryChip(title: "CBC", icon: "drop.fill")
                        categoryChip(title: "Blood", icon: "drop")
                        categoryChip(title: "Micro", icon: "bandage")
                        categoryChip(title: "Tests", icon: "list.bullet")
                    }
                    .padding(.horizontal)
                    
                    // Selected Tests Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Selected Test")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("2/8")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.cyan)
                                .frame(width: 50, height: 50)
                                .background(Color.cyan.opacity(0.2))
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("Complete Blood Count")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Text("LKR 850 Wing")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("LKR 850")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Choose Your Test Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose your test")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        testCard(title: "ESR", subtitle: "Erythrocyte Sedimentation Rate", price: "LKR 250", icon: "flame.fill")
                        testCard(title: "Hemoglobin", subtitle: "Hb Quantitative", price: "LKR 450", icon: "heart.fill")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.black)
            .navigationTitle("Find Lab")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private func categoryChip(title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.2))
        .cornerRadius(20)
    }
    
    @ViewBuilder
    private func testCard(title: String, subtitle: String, price: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.cyan)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(Color.cyan.opacity(0.1))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(price)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                Text("Wing")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
    }
}
struct FindLabView_Previews: PreviewProvider {
    static var previews: some View {
        FindLabView()
    }
}
