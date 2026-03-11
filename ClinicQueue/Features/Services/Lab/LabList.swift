//
//  LabList.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-06.
//

import SwiftUI

struct LabList: View {

    let specialties: [CategoryItem] = LabCategoriesData.categories
    @StateObject private var session = SessionManagerV2()

    let labTests: [LabCardData] = LabData.labTests

    @State private var selectedTests: Set<UUID> = []
    @State private var showingSelectedSection = false
    @State private var selectedCategories: Set<String> = []
    @State private var selectedCategory: String? = nil
    @State private var isNavigatingToDetails = false
    @State private var searchText = ""
    @State private var navigateToNext = false


    private var filteredLabTests: [LabCardData] {
        if searchText.isEmpty {
            return labTests
        } else {
            return labTests.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
 
    private var selectedLabCards: [LabCardData] {
        filteredLabTests.filter { selectedTests.contains($0.id) }
    }
    

    private var availableLabCards: [LabCardData] {
        filteredLabTests.filter { !selectedTests.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HeaderSection(title: "Find Lab Test")
                    }
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
                            ForEach(selectedLabCards) { test in
                                BloodTestCard(
                                    image: test.icon,
                                    title: test.title,
                                    specialText: "Available Now",
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

                    if !availableLabCards.isEmpty {
                        Text("Choose Your Lab Test")
                            .font(.app(.heading))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 32)
                            .padding(.horizontal, 10)

                        VStack(spacing: 12) {
                            ForEach(availableLabCards) { test in
                                BloodTestCard(
                                    image: test.icon,
                                    title: test.title,
                                    specialText: "Available Now",
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
                        .padding(.top, 20).onAppear{
                            session.currentService = .lab
                        }
                    }

                    HStack {
                        PrimaryButton(title: "Next", maxWidth: 160) {
                            navigateToNext = true
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
            .navigationDestination(isPresented: $navigateToNext) {
                LabTestDetailsView(selectedTests: selectedLabCards)
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

struct LabListView_Previews: PreviewProvider {
    static var previews: some View {
        LabList()
    }
}
