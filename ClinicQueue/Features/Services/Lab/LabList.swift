//
//  LabList.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-06.
//

import SwiftUI

struct LabList: View {
    let specialties = [
        "General Physician",
        "Cardiologist",
        "Dermatologist",
        "Pediatrician",
        "Gynecologist",
        "Orthopedic Surgeon",
        "Neurologist",
        "Psychiatrist",
    ]
    
   
    let labTests: [LabCardData] = [
        LabCardData(
            icon: "SearchIcon",
            iconSize: 32,
            title: "Complete Blood Count (CBC)",
            description1: "45 patients in queue",
            label1: "Estimated wait: ",
            label1Text: "~25 min",
            label2: "Location: ",
            label2Text: "Lab 02 – Main Wing",
            buttonText: "Fee $15"
        ),
        LabCardData(
            icon: "SearchIcon",
            iconSize: 32,
            title: "Lipid Profile",
            description1: "23 patients in queue",
            label1: "Estimated wait: ",
            label1Text: "~15 min",
            label2: "Location: ",
            label2Text: "Lab 05 – East Wing",
            buttonText: "Fee $25"
        ),
        LabCardData(
            icon: "SearchIcon",
            iconSize: 32,
            title: "Thyroid Function Test",
            description1: "18 patients in queue",
            label1: "Estimated wait: ",
            label1Text: "~20 min",
            label2: "Location: ",
            label2Text: "Lab 03 – West Wing",
            buttonText: "Fee $30"
        ),
        LabCardData(
            icon: "SearchIcon",
            iconSize: 32,
            title: "Urinalysis",
            description1: "12 patients in queue",
            label1: "Estimated wait: ",
            label1Text: "~10 min",
            label2: "Location: ",
            label2Text: "Lab 08 – North Wing",
            buttonText: "Fee $12"
        ),
        LabCardData(
            icon: "SearchIcon",
            iconSize: 32,
            title: "Liver Function Test",
            description1: "30 patients in queue",
            label1: "Estimated wait: ",
            label1Text: "~35 min",
            label2: "Location: ",
            label2Text: "Lab 12 – South Wing",
            buttonText: "Fee $28"
        )
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    @State private var selectedTests: Set<UUID> = []
    @State private var navigate = false
    @State private var showingSelectedSection = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {

                VStack(alignment: .center) {
                    // Empty VStack as in original
                }

                Text("Category")
                    .font(.app(.heading))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(specialties, id: \.self) { specialty in
                        CategoryButton(title: specialty, icon: "SearchIcon", iconWidth: 38) {
                            print("category clicked: \(specialty)")
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .padding(.top, 20)

                // ---------------------------
                // SELECTED TESTS FIRST
                // ---------------------------
                if !selectedTests.isEmpty {

                    Text("Selected Tests")
                        .font(.app(.heading))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)

                    VStack(spacing: 12) {

                        ForEach(labTests.filter { selectedTests.contains($0.id) }) { test in

                            SelectableLabCard(
                                props: test,
                                isSelected: true,
                                onTap: {
                                    toggleSelection(test.id)
                                },
                                onButtonTap: {
                                    print("Fee button tapped for: \(test.title)")
                                }
                            )
                        }

                    }
                    .padding(.top, 20)
                }

                // ---------------------------
                // CHOOSE TEST (UNSELECTED)
                // ---------------------------

                Text("Choose Your Lab Test")
                    .font(.app(.heading))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)

                VStack(spacing: 12) {

                    ForEach(labTests.filter { !selectedTests.contains($0.id) }) { test in

                        SelectableLabCard(
                            props: test,
                            isSelected: false,
                            onTap: {
                                toggleSelection(test.id)
                            },
                            onButtonTap: {
                                print("Fee button tapped for: \(test.title)")
                            }
                        )
                    }

                }
                .padding(.top, 20)


                HStack {
                    PrimaryButton(title: "Next", maxWidth: 160) {
                        print("Selected tests: \(selectedTests.count)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
                .disabled(selectedTests.isEmpty)
                .opacity(selectedTests.isEmpty ? 0.5 : 1.0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 0)
            .padding(.bottom, 32)
            .animation(.spring(), value: selectedTests.isEmpty)
        }
        .safeAreaInset(edge: .top) {
            HeaderSection(title: "Find Lab Test")
        }
    }
    
    private func toggleSelection(_ id: UUID) {
        withAnimation(.spring()) {
            if selectedTests.contains(id) {
                selectedTests.remove(id)
            } else {
                selectedTests.insert(id)
            }
        }
    }
    
   
}


struct LabListView_Previews: PreviewProvider {
    static var previews: some View {
        LabList()
    }
}
