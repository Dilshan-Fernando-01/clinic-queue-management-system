//
//  FindDoctorView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct FindDoctorView: View {
    
    @State private var doctorName: String = ""
    @State private var selectedCategories: Set<String> = []
    

    private var allDoctors: [InfoCardData] {
        DoctorData.doctorGroups.flatMap { $0.doctors }
    }
    

    private var filteredDoctors: [InfoCardData] {
        
        var doctors = allDoctors
        
        if !selectedCategories.isEmpty {
            doctors = DoctorData.doctorGroups
                .filter { selectedCategories.contains($0.specialty) }
                .flatMap { $0.doctors }
        }
        

        if !doctorName.isEmpty {
            doctors = doctors.filter {
                $0.heading.lowercased().contains(doctorName.lowercased())
            }
        }
        
        return doctors
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Find Available Doctors")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    IconInputField(
                        iconName: "SearchIcon",
                        placeholder: "Find a Doctor",
                        value: $doctorName
                    )
                    .padding(.top, Spacing.section)
                    
                    
                    HStack {
                        Text("Category")
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                        
                        Text("See all")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                            .onTapGesture {
                                selectedCategories = []
                            }
                    }
                    .padding(.top, Spacing.section)
                    
                    

                    CategoryGrid(
                        items: DoctorCategoriesData.categories,
                        selectedCategories: $selectedCategories
                    )
                    .padding(.top, 10)
                    
                    

                    HStack {
                        Text("Available Doctors")
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                        
                        Text("\(filteredDoctors.count)")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.top, Spacing.section)
                    
                    
   
                    VStack(spacing: 10) {
                        ForEach(filteredDoctors.indices, id: \.self) { index in
                            InfoCard(data: filteredDoctors[index])
                        }
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    FindDoctorView()
}
