//
//  FindDoctorView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct FindDoctorView: View {
    
    @State private var doctorName: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Find Available Doctors")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, Spacing.section)
                    
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
                             }   .padding(.top, Spacing.section)
                    
                    
                    CategoryGrid(items: DoctorCategoriesData.categories)
                        .padding(.top, 10)
                    
                    HStack {
                      Text("Available  Doctors")
                      .font(.system(size: 18, weight: .bold))
                                 
                       Spacer()
                                 
                       Text("See all")
                       .foregroundColor(.gray)
                        .font(.system(size: 14))
                             }   .padding(.top, Spacing.section)
                     
                }
                .padding()
            }
        }
    }
}
#Preview {
    FindDoctorView()
}
