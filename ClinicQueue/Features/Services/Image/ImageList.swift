//
//  ImageList.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-10.
//


import SwiftUI

struct ImageList: View {

    let specialties: [CategoryItem] = LabCategoriesData.categories

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
            buttonText: "$15"
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
            buttonText: "$25"
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
            buttonText: "$30"
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
            buttonText: "$12"
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
            buttonText: "$28"
        )
    ]

    @State private var selectedTests: Set<UUID> = []
    @State private var showingSelectedSection = false
    @State private var selectedCategories: Set<String> = []
    @State private var selectedCategory: String? = nil
    @State private var isNavigatingToDetails = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {

                    VStack(alignment: .leading, spacing: 20) {
                        HeaderSection(title: "Find Lab Test")}
                    .padding(.top ,-60)

                    Text("Category")
                        .font(.app(.heading))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)
                        .padding(.horizontal, 10)

                    CategoryGrid(
                        items: specialties,
                        selectedCategories: $selectedCategories
                    )
                
                    .onChange(of: selectedCategories) { newValue in
                        if let tapped = newValue.first {
                            selectedCategory = tapped
                            isNavigatingToDetails = true
                           
                            selectedCategories = []
                        }
                    }
                    .padding(.top, 20)

                    if !selectedTests.isEmpty {
                        Text("Selected Tests")
                            .font(.app(.heading))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 32)
                            .padding(.horizontal, 10)

                        VStack(spacing: 12) {
                            ForEach(labTests.filter { selectedTests.contains($0.id) }) { test in
                                BloodTestCard(
                                    image: test.icon,
                                    title: test.title,
                                    specialText: test.description1,
                                    detailLine1: "\(test.label1)\(test.label1Text)",
                                    detailLine2: "\(test.label2)\(test.label2Text)",
                                    showExtraSection: false,
                                    fee: test.buttonText,
                                    onButtonTap: {
                                        print("Fee button tapped for: \(test.title)")
                                    },
                                    isCheckboxSelectable: true,
                                    initiallySelected: true,
                                    onSelectionChange: { isSelected in
                                        if !isSelected { toggleSelection(test.id) }
                                    }
                                )
                            }
                        }
                        .padding(.top, 20)
                    }

                    Text("Choose Your Lab Test")
                        .font(.app(.heading))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)
                        .padding(.horizontal, 10)
                    

                    VStack(spacing: 12) {
                        ForEach(labTests.filter { !selectedTests.contains($0.id) }) { test in
                            BloodTestCard(
                                image: test.icon,
                                title: test.title,
                                specialText: test.description1,
                                detailLine1: "\(test.label1)\(test.label1Text)",
                                detailLine2: "\(test.label2)\(test.label2Text)",
                                showExtraSection: false,
                                fee: test.buttonText,
                                onButtonTap: {
                                    print("Fee button tapped for: \(test.title)")
                                },
                                isCheckboxSelectable: true,
                                initiallySelected: false,
                                onSelectionChange: { isSelected in
                                    if isSelected { toggleSelection(test.id) }
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
                .padding(.horizontal, 2)
                .padding(.top, 0)
                .padding(.bottom, 32)
                .animation(.spring(), value: selectedTests.isEmpty)
            }
         
            .navigationDestination(isPresented: $isNavigatingToDetails) {
                if let category = selectedCategory {
                    LabDetails(selectedCategory: category)
                }
            }
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

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        ImageList()
    }
}
