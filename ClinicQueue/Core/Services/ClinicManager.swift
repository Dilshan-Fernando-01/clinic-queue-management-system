//
//  ClinicManager.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

//
//  ClinicManager.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-09.
//

import SwiftUI
import Combine

class ClinicManager: ObservableObject {
    @Published var sessions: [PatientSession] = []


    func startSession(name: String, age: Int, gender: String) -> UUID {
        let session = PatientSession(name: name, age: age, gender: gender)
        sessions.append(session)
        return session.id
    }


    func getSession(id: UUID) -> PatientSession? {
        sessions.first { $0.id == id }
    }


    func updateSession(_ session: PatientSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        }
    }


    func advanceClinicQueue(for sessionId: UUID) {
        guard var session = getSession(id: sessionId) else { return }
        switch session.clinicQueueStep {
        case .waiting: session.clinicQueueStep = .ready
        case .ready: session.clinicQueueStep = .inProgress
        case .inProgress: session.clinicQueueStep = .completed
        case .completed: break
        }
        updateSession(session)
    }


    func addLabTest(for sessionId: UUID, test: LabTest) {
        guard var session = getSession(id: sessionId) else { return }
        session.labQueue.append(test)
        updateSession(session)
    }

    func completeLabTest(for sessionId: UUID, testId: UUID) {
        guard var session = getSession(id: sessionId) else { return }
        if let index = session.labQueue.firstIndex(where: { $0.id == testId }) {
            session.labQueue[index].isCompleted = true
        }
        updateSession(session)
    }


    func finishSession(for sessionId: UUID) {
        guard var session = getSession(id: sessionId) else { return }
        session.isSessionComplete = true
        updateSession(session)
    }
}
