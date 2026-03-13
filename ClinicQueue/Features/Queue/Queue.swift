import SwiftUI

extension QueueStages {
    func toQueueStage() -> QueueStage {
        switch self {
        case .wait: return .wait
        case .next: return .next
        case .ready: return .ready
        case .inProgress: return .inProgress
        case .completed: return .completed
        case .unknown: return .wait
        case .cancel: return .completed
        }
    }
}

struct Queue: View {

    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var session: SessionManagerV2
    
    @State private var showRescheduleAlert = false
    
    @State private var hasRechecked = false

    @State private var simulatedStatus: StepStatus = .waiting
    @State private var navigateToAppointment = false


    private var activeActivity: Activity? {
        session.activities.first(where: {
            $0.service == session.currentService &&
            $0.isSelected &&
            $0.queueStage != .cancel
        })
    }

  
    private var requestedActivities: [Activity] {
        session.activities.filter {
            $0.service == session.currentService &&
            $0.queueStage == .unknown
        }
    }

  
    private var completedActivities: [Activity] {
        session.activities.filter {
            $0.service == session.currentService &&
            $0.queueStage == .completed
        }
    }

 
    private var canRecheckWithDoctor: Bool {
        guard session.currentService == .clinic || session.currentService == .appointment else { return false }

        if hasRechecked { return false }

        let serviceActivities = session.activities.filter { $0.service == session.currentService }
        let hasCompletedTests = serviceActivities.contains { $0.queueStage == .completed }
        let allCompletedOrCancelled = serviceActivities.allSatisfy { $0.queueStage == .completed || $0.queueStage == .cancel }

        return hasCompletedTests && allCompletedOrCancelled
    }

    private func getQueueNumber(for activity: Activity) -> Int {
        if let doctor = activity.selectedDoctor,
           let countString = doctor.activeQueueCount,
           let count = Int(countString) {
            return count + 1
        }
        return 14
    }

    private func getNowServingNumber(for queue: Int) -> Int {
        max(queue - 2, 1)
    }

    private func mapQueueStage(for status: StepStatus) -> QueueStages {
        switch status {
        case .pending, .waiting: return .wait
        case .next: return .next
        case .ready: return .ready
        case .inProgress: return .inProgress
        case .completed: return .completed
        }
    }

    private func updateActiveActivityQueue() {
        guard let activity = activeActivity else { return }
        if let index = session.activities.firstIndex(where: { $0.id == activity.id }) {
            session.activities[index].queueStage = mapQueueStage(for: simulatedStatus)
        }
    }

    private func startQueueSimulation() {
        let steps: [StepStatus] = [.next, .ready, .inProgress, .completed]
        for (i, status) in steps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double((i + 1) * 5)) {
                simulatedStatus = status
                updateActiveActivityQueue()
            }
        }
    }

    private func startRequestedActivity(_ activity: Activity) {
        guard simulatedStatus == .completed else { return }
        guard let tappedIndex = session.activities.firstIndex(where: { $0.id == activity.id }) else {
            return
        }

        let serviceType = session.activities[tappedIndex].service
  
        for index in session.activities.indices where session.activities[index].service == serviceType {
            session.activities[index].isSelected = false
        }

 
        session.activities[tappedIndex].isSelected = true
        session.activities[tappedIndex].queueStage = .unknown
        navigateToAppointment = true
    }
    
    private func rescheduleActivity(_ activity: Activity) {

        guard let index = session.activities.firstIndex(where: { $0.id == activity.id }) else {
     
            return
        }

        let removed = session.activities.remove(at: index)

        switch removed.service {
        case .lab:
            session.scheduledLab.append(removed)
         
        case .imaging:
            session.scheduledTest.append(removed)
           
        default:
            print("No scheduled array for this service")
        }
        
        showRescheduleAlert = true

        session.activities = session.activities

        for act in session.activities {
            print(" - \(act.testName ?? "Unknown") [\(act.queueStage.rawValue)]")
        }
    }

   
    private func recheckWithDoctor() {
        guard let doctorActivity = session.activities.first(where: {
            $0.service == session.currentService && $0.selectedDoctor != nil
        }) else { return }

        if let index = session.activities.firstIndex(where: { $0.id == doctorActivity.id }) {
            session.activities[index].isSelected = true
            session.activities[index].queueStage = .wait
        }

        for index in session.activities.indices where session.activities[index].id != doctorActivity.id {
            session.activities[index].isSelected = false
        }

        simulatedStatus = .waiting
        hasRechecked = true           
        startQueueSimulation()
    }

  
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                  
                    if let activity = activeActivity {
                        let qNumber = getQueueNumber(for: activity)
                        let nowServing = getNowServingNumber(for: qNumber)

                        QueueBanner(
                            queueNumber: String(qNumber),
                            queueStage: mapQueueStage(for: simulatedStatus).toQueueStage(),
                            nowServingNumber: String(nowServing),
                            estimatedWait: "~15 minutes"
                        )
                        .padding(.horizontal, 20)
                    }

                    VStack(alignment: .leading, spacing: 24) {

                       
                        if simulatedStatus == .completed {

                          
                            if !completedActivities.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Completed Services")
                                        .font(.system(size: 22, weight: .bold))
                                        .padding(.horizontal, 30)
                                        .padding(.top, 40)

                                    ForEach(completedActivities, id: \.id) { activity in
                                        activityCard(activity)
                                    }
                                }
                            }

                          
                            if !requestedActivities.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Requested Services")
                                        .font(.system(size: 22, weight: .bold))
                                        .padding(.horizontal, 30)

                                    ForEach(requestedActivities, id: \.id) { activity in
                                        activityCard(activity)
                                    }
                                }
                            }

                            
                            if canRecheckWithDoctor {
                                VStack(spacing: 16) {
                                    Button(action: {
                                        recheckWithDoctor()
                                    }) {
                                        Text("Recheck with Doctor")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 24)
                                            .background(Color(red: 0.28, green: 0.58, blue: 0.53))
                                            .cornerRadius(25)
                                    }
                                    .buttonStyle(.plain)

                                    Button(action: {
                                        ServicesView()
                                    }) {
                                        Text("Leave Clinic")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(red: 0.28, green: 0.58, blue: 0.53))
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 24)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color(red: 0.28, green: 0.58, blue: 0.53), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 30)
                                .multilineTextAlignment(.center)
                            }
                        } else {
                            
                            if let activity = activeActivity {
                                activityCard(activity, showHeader: true)
                            }
                        }

                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .background(Color(white: 0.95))
            .alert("Rescheduled Successfully", isPresented: $showRescheduleAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("You can check your scheduled activities in the settings page.")
                    }
                    .onAppear {
                        startQueueSimulation()
                    }
            .onAppear {
                startQueueSimulation()
            }
            .navigationDestination(isPresented: $navigateToAppointment) {
                
                
                AppointmentStarterView()
            }
            
            
        }.overlay(
            FloatingNav(
                mainIcon: "plus",
                items: [
                    FloatingNavItem(icon: "house.fill", label: "Home", destination: AnyView(ServicesView())),
                    FloatingNavItem(icon: "map.fill", label: "Map", destination: AnyView(Text("Map View"))),
                    FloatingNavItem(icon: "gearshape.fill", label: "Settings", destination: AnyView(ProfileView()))
                ]
            )
            .padding(.trailing, 30)
            .padding(.bottom, 30),
            alignment: .bottomTrailing
        )
    }

 
    @ViewBuilder
    private func activityCard(_ activity: Activity, showHeader: Bool = false) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            if showHeader {
                Text("Service")
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 30)
                    .padding(.top, 40)
            }

            if let doctor = activity.selectedDoctor {
                InfoCard(data: doctor)
                    .padding(.horizontal, 30)
            } else {
                BloodTestCard(
                    image: TestDataset.imageName(for: activity.testName ?? ""),
                    title: activity.testName ?? "Test",
                    specialText: "",
                    detailLine1: "Location: \(activity.labStep?.location ?? "N/A")",
                    detailLine2: "",
                    showExtraSection: true,
                    bottomTitleLeft: "Requirements",
                    listItems: activity.labStep?.requirements ?? [],
                    bottomTitleRight: "Approximate Time",
                    bottomSubTextRight: activity.labStep?.estimatedWait ?? "",
                    fee: activity.labStep?.price != nil ? "$\(Int(activity.labStep!.price!))" : "Free",
                    onButtonTap: {
                        startRequestedActivity(activity)
                    },
                    onRescheduleTap: {
                        print("rescheduleActivity called in directly:")
                        rescheduleActivity(activity)
                    },
                    isActiveQueue: requestedActivities.contains(where: { $0.id == activity.id })
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    Queue()
}
