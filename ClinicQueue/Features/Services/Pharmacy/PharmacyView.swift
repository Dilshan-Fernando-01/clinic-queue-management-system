//
//  PharmacyView.swift
//  ClinicQueue
//
//  Created by Roshan on 2026-03-12.
//

import SwiftUI

// MARK: - Models

struct Drug: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let price: Double
    let imageName: String
    let color: Color
}

struct DrugCard: View {
    let drug: Drug
    @State private var addedToCart = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(drug.color.opacity(0.12))
                    .frame(height: 110)

                Image(systemName: drug.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(drug.color)
            }
            .padding(.bottom, 10)

            Text(drug.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(2)

            Text(drug.subtitle)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.top, 2)

            HStack {
                Text(String(format: "$%.2f", drug.price))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        addedToCart = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { addedToCart = false }
                    }
                } label: {
                    Image(systemName: addedToCart ? "checkmark" : "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(addedToCart ? Color.green : Color(hex: "1A2E44"))
                        .cornerRadius(6)
                }
            }
            .padding(.top, 8)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Prescription Banner

struct PrescriptionBanner: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Order quickly with\nprescription")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "1A2E44"))
                    .lineSpacing(3)

                Button {
                    // Upload action
                } label: {
                    Text("Upload Prescription")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color(hex: "0DC8A4"))
                        .cornerRadius(25)
                }
            }
            .padding(.leading, 20)
            .padding(.vertical, 22)

            Spacer()

            ZStack {
                Circle()
                    .fill(Color(hex: "0DC8A4").opacity(0.15))
                    .frame(width: 90, height: 90)
                    .offset(x: 10, y: -10)

                VStack(spacing: -8) {
                    Image(systemName: "cross.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                        .offset(x: 10, y: 0)

                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 42))
                        .foregroundColor(Color(hex: "C8E6FF"))

                    Image(systemName: "pills.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: "FFD700"))
                        .offset(x: -5, y: -8)
                }
            }
            .padding(.trailing, 10)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "E6F9F5"), Color(hex: "D0F0FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(18)
        .shadow(color: Color(hex: "0DC8A4").opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Search Bar

struct PharmacySearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))

            TextField("Search drugs, category", text: $text)
                .font(.system(size: 15))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let label: String
    let icon: String
    @Binding var selected: String

    var isSelected: Bool { selected == label }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { selected = label }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color(hex: "1A2E44"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color(hex: "0DC8A4") : Color(.systemGray6))
            .cornerRadius(20)
        }
    }
}

// MARK: - Main Pharmacy View

struct PharmacyView: View {
    @State private var searchText = ""
    @State private var cartCount = 0
    @State private var selectedCategory = "All"

    let categories = [
        ("All", "square.grid.2x2.fill"),
        ("Vitamins", "leaf.fill"),
        ("Pain Relief", "cross.fill"),
        ("Antibiotics", "waveform.path.ecg"),
        ("Skincare", "sparkles")
    ]

    let drugs: [Drug] = [
        Drug(name: "PANADOL TABLETS", subtitle: "20pcs", price: 10.99,
             imageName: "pills.fill", color: Color(hex: "E74C3C")),
        Drug(name: "Lipitor Atorvastatin", subtitle: "20pcs", price: 10.99,
             imageName: "cross.case.fill", color: Color(hex: "3498DB")),
        Drug(name: "Ibuprofen", subtitle: "200mg", price: 10.99,
             imageName: "humidity.fill", color: Color(hex: "E67E22")),
        Drug(name: "Levothyroxine", subtitle: "20pcs", price: 10.99,
             imageName: "capsule.fill", color: Color(hex: "9B59B6")),
        Drug(name: "Amoxicillin", subtitle: "500mg · 30 caps", price: 14.99,
             imageName: "waveform.path.ecg", color: Color(hex: "27AE60")),
        Drug(name: "Vitamin D3", subtitle: "1000IU · 60 tabs", price: 8.99,
             imageName: "sun.max.fill", color: Color(hex: "F39C12"))
    ]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        // Search Bar
                        PharmacySearchBar(text: $searchText)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)

                        // Categories
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(categories, id: \.0) { cat in
                                    CategoryChip(
                                        label: cat.0,
                                        icon: cat.1,
                                        selected: $selectedCategory
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // Prescription Banner
                        PrescriptionBanner()
                            .padding(.horizontal, 16)

                        // Popular Products Header
                        HStack {
                            Text("Popular Product")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: "1A2E44"))
                            Spacer()
                            Button {
                                // See all
                            } label: {
                                Text("See all")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "0DC8A4"))
                            }
                        }
                        .padding(.horizontal, 16)

                        // Drug Grid
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(filteredDrugs) { drug in
                                DrugCard(drug: drug)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }

                // Floating Nav
                FloatingNav(
                    mainIcon: "plus",
                    items: [
                        FloatingNavItem(
                            icon: "house.fill",
                            label: "Home",
                            destination: AnyView(EmptyView())
                        ),
                        FloatingNavItem(
                            icon: "map.fill",
                            label: "Map",
                            destination: AnyView(Text("Map View").font(.title))
                        ),
                        FloatingNavItem(
                            icon: "gearshape.fill",
                            label: "Settings",
                            destination: AnyView(ProfileView())
                        )
                    ]
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pharmacy")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "1A2E44"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack(alignment: .topTrailing) {
                        Button {
                            // Cart
                        } label: {
                            Image(systemName: "cart")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "1A2E44"))
                        }
                        if cartCount > 0 {
                            Text("\(cartCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color(hex: "0DC8A4"))
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
            }
        }
    }

    var filteredDrugs: [Drug] {
        if searchText.isEmpty { return drugs }
        return drugs.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}




#Preview {
    PharmacyView()
}
