//
//  PharmacyView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-12.
//

import SwiftUI

struct Drug: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let price: Double
    let imageName: String
    let color: Color
}

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

                        VStack(alignment: .center) {
                            IconInputField(
                                iconName: "SearchIcon",
                                placeholder: "Find a Lab Test",
                                value: $searchText
                            )
                            .padding(.top, 10)
                            .padding(.horizontal, 10)
                        }

                     
                        ScrollView(.horizontal, showsIndicators: false) {
                          
                        
                        }

                      
                        PrescriptionBanner()
                            .padding(.horizontal, 16)

                   
                        HStack {
                            Text("Popular Product")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: "1A2E44"))
                            Spacer()
                           
                        }
                        .padding(.horizontal, 16)

                       
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(filteredDrugs) { drug in
                                DrugCard(drug: drug)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }

            
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
