//
//  ContentView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-02-07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .padding(.horizontal, 16)
        }
        .onAppear {
            for family in UIFont.familyNames {
                print("Family:", family)

                for name in UIFont.fontNames(forFamilyName: family) {
                    print("   Font:", name)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
