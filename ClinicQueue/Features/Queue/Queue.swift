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
            !$0.isSelected &&
            $0.queueStage != .cancel
        }
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
        case .pending: return .wait
        case .waiting: return .wait
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

        for index in session.activities.indices {

            if session.activities[index].service == serviceType {
                session.activities[index].isSelected = false
            }
        }

        session.activities[tappedIndex].isSelected = true

        session.activities[tappedIndex].queueStage = .unknown

        navigateToAppointment = true
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

                        if simulatedStatus == .completed && !requestedActivities.isEmpty {

                            VStack(alignment: .leading, spacing: 16) {

                                Text("Requested Services")
                                    .font(.system(size: 22, weight: .bold))
                                    .padding(.horizontal, 30)

                                ForEach(requestedActivities, id: \.id) { activity in
                                    activityCard(activity)
                                }
                            }
                        }

                        if let activity = activeActivity {

                            activityCard(activity, showHeader: true)
                        }

                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .background(Color(white: 0.95))
            .onAppear {
                startQueueSimulation()
            }
            .navigationDestination(isPresented: $navigateToAppointment) {
                AppointmentStarterView()
            }
        }
    }

    @ViewBuilder
    private func activityCard(_ activity: Activity, showHeader: Bool = false) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            if showHeader {
                Text("Service")
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 30)
            }

            if let doctor = activity.selectedDoctor {

                InfoCard(data: doctor)
                    .padding(.horizontal, 30)

            } else {

                BloodTestCard(
                    image: "doctor01",
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
                    isActiveQueue: true
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    Queue()
}
