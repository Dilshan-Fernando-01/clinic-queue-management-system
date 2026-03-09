//
//  QueueReady.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-09.
//

import SwiftUI

struct QueueReady: View {
    
    var queueNumber: String = "11"
    var nowServing: String = "05"
    var estimatedWait: String = "~15 minutes"
    
    var body: some View {
        ZStack {
            Image("welcome_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                Spacer()
                
                VStack(spacing: 26) {
                    Text("Your Queue Number")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(queueNumber)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(20)
                }
                
                VStack(spacing: 12) {
                    Text("Now Serving")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(nowServing)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 60)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)
                }
                
                // Wait Time Section
                VStack(spacing: 8) {
                    Text("Estimated Wait Time")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(estimatedWait)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(20)
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    QueueReady()
}
