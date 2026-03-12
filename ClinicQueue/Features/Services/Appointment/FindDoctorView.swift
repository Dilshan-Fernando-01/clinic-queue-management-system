import SwiftUI

struct FindDoctorView: View {
    
    @StateObject private var session = SessionManagerV2()
    @State private var doctorName: String = ""
    @State private var selectedCategories: Set<String> = []
    @State private var isCategoryModalPresented = false
    @State private var categorySearch: String = ""
    @State private var selectedDoctor: InfoCardData?
    @State private var selectedAvailabilityId: String?
    @State private var navigateToAppointment = false
    @State private var isAvailabilityModalPresented = false
    @State private var selectedAvailabilityDate: Date? = nil
    
    func saveAppointment(
        patientName: String,
        patientAge: Int,
        patientGender: String,
        selectedDate: Date
    ) {
 
        
        let appointmentActivities = session.activities.filter { $0.service == .appointment }
        let activitiesWithPatientInfo = appointmentActivities.map { activity -> Activity in
            var updated = activity
            updated.service = .appointment
            updated.patientName = patientName
            updated.patientAge = patientAge
            updated.patientGender = patientGender
            updated.appointmentDate = selectedDate
            return updated
        }
        
        let totalFee = activitiesWithPatientInfo.reduce(0.0) { partial, activity in
            var fee = 0.0
            if activity.labStep != nil { fee += 25 }
            if activity.imagingStep != nil { fee += 25 }
            if activity.pharmacyStep != nil { fee += 25 }
            return partial + fee
        }
        
        let newAppointment = UpcomingAppointment(
            id: UUID(),
            date: selectedDate,
            patientName: patientName,
            age: patientAge,
            gender: patientGender,
            activities: activitiesWithPatientInfo,
            totalFee: totalFee
        )
        
        session.upcomingAppointments.append(newAppointment)
        session.activities.removeAll { $0.service == .appointment }
   
    }
    
 
    private func assignDoctorToAppointment(_ doctor: InfoCardData, date: Date? = nil) {
      
        
        var appointmentActivity: Activity
        if let existingIndex = session.activities.firstIndex(where: { $0.service == .appointment && $0.testName == nil }) {
            appointmentActivity = session.activities[existingIndex]
           
        } else {
            appointmentActivity = Activity(service: .appointment)
            session.activities.append(appointmentActivity)
        }
        
 
        appointmentActivity.selectedDoctor = doctor
        appointmentActivity.appointmentDate = date
        appointmentActivity.isSelected = true
        appointmentActivity.stage = .planning
        appointmentActivity.patientName = "John Doe"
        appointmentActivity.patientAge = 28
        appointmentActivity.patientGender = "Male"
        
        if let existingIndex = session.activities.firstIndex(where: { $0.id == appointmentActivity.id }) {
            session.activities[existingIndex] = appointmentActivity
        } else {
            session.activities.append(appointmentActivity)
        }
        
        
        for index in session.activities.indices where session.activities[index].service != .appointment || session.activities[index].testName != nil {
            session.activities[index].isSelected = false
        }
        
        let recommendedTests = TestRecommendation.recommendedTests(forDoctorSpecialty: doctor.subheading)
        var testActivities: [Activity] = []
        
        for test in recommendedTests {
            let testActivity = Activity(
                id: UUID(),
                service: .appointment,
                stage: .unknown,
                doctor: nil,
                selectedDoctor: doctor,
                queueNumber: nil,
                isSelected: false,
                queueStage: .unknown,
                labStep: test.type == .labTest ? test : nil,
                imagingStep: test.type == .imaging ? test : nil,
                pharmacyStep: nil,
                appointmentDate: date,
                patientName: appointmentActivity.patientName,
                patientAge: appointmentActivity.patientAge,
                patientGender: appointmentActivity.patientGender,
                symptoms: [],
                testName: test.name
            )
            testActivities.append(testActivity)
        }
        
        session.activities.removeAll { $0.service == .appointment && $0.testName != nil && $0.selectedDoctor?.heading == doctor.heading }
        session.activities.append(contentsOf: testActivities)
        

    }
    
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
    
    private var modalCategories: [CategoryItem] {
        if categorySearch.isEmpty {
            return DoctorCategoriesData.categories
        } else {
            return DoctorCategoriesData.categories.filter {
                $0.title.lowercased().contains(categorySearch.lowercased())
            }
        }
    }
    
    private var defaultGridCategories: [CategoryItem] {
        var selectedItems = DoctorCategoriesData.categories.filter { selectedCategories.contains($0.title) }
        let unselectedItems = DoctorCategoriesData.categories.filter { !selectedCategories.contains($0.title) }
        let remainingCount = max(0, 8 - selectedItems.count)
        selectedItems.append(contentsOf: unselectedItems.prefix(remainingCount))
        return Array(selectedItems.prefix(8))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                                .onTapGesture { isCategoryModalPresented = true }
                        }
                        .padding(.top, Spacing.section)
                        
                        CategoryGrid(
                            items: defaultGridCategories,
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
                                InfoCard(
                                    data: filteredDoctors[index],
                                    onPriceTap: {
                                        selectedDoctor = filteredDoctors[index]
                                        isAvailabilityModalPresented = true
                                    }
                                )
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
                
                CustomModal(isPresented: $isCategoryModalPresented) {
                    VStack(spacing: 16) {
                        Text("Select Categories")
                            .font(.title3.bold())
                            .padding(.bottom, 10)
                        IconInputField(
                            iconName: "SearchIcon",
                            placeholder: "Search Categories",
                            value: $categorySearch
                        )
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
                            ForEach(modalCategories) { category in
                                CategoryBoxGrid(
                                    item: category,
                                    isSelected: selectedCategories.contains(category.title)
                                ) {
                                    if selectedCategories.contains(category.title) {
                                        selectedCategories.remove(category.title)
                                    } else {
                                        selectedCategories.insert(category.title)
                                    }
                                }
                            }
                        }
                        .padding(.top, Spacing.section)
                    }
                }
                
                CustomModal(isPresented: $isAvailabilityModalPresented) {
                    VStack {
                        if let doctor = selectedDoctor {
                            DoctorAvailabilitySelector(
                                items: doctor.availableDates ?? [],
                                selectedDate: $selectedAvailabilityDate
                            )
                            .onChange(of: selectedAvailabilityDate) { newDate in
                                if let selectedDate = newDate, let doctor = selectedDoctor {
                                    assignDoctorToAppointment(doctor, date: selectedDate)
                                    saveAppointment(
                                        patientName: "John Doe",
                                        patientAge: 28,
                                        patientGender: "Male",
                                        selectedDate: selectedDate
                                    )
                                    navigateToAppointment = true
                                    isAvailabilityModalPresented = false
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Navigation
                if let doctor = selectedDoctor {
                    NavigationLink(
                        destination: DoctorAppointmentStarterView(doctor: doctor),
                        isActive: $navigateToAppointment
                    ) {
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            session.currentService = .appointment
        }
    }
}

#Preview {
    FindDoctorView()
}
