//
//  InfoCard.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//
import SwiftUI

struct InfoCardData {
    let image: Image
    let heading: String
    let subheading: String
    let activeQueueCount: String?
    let detail1: (label: String, value: String)?
    let detail2: (label: String, value: String)?
}

struct InfoCard: View {
    let data: InfoCardData
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            
            // LEFT IMAGE
            data.image
                .resizable()
                .scaledToFill()
                .frame(width: 85, height: 85)
                .clipShape(Circle())
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
            
            // RIGHT SECTION
            VStack(alignment: .leading, spacing: 8) {
                
                // displayTextSection
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.heading)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.heading)
                    
                    Text(data.subheading)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.placeholder)
                }
                
                // displayTextSubSection
                VStack(alignment: .leading, spacing: 4) {
                    
                    if let queue = data.activeQueueCount {
                        Text(queue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.primary)
                    }
                    
                    if let detail1 = data.detail1 {
                        HStack(spacing: 4) {
                            Text(detail1.label)
                                .foregroundColor(AppColors.text)
                            
                            Text(detail1.value)
                                .foregroundColor(AppColors.heading)
                        }
                        .font(.system(size: 12))
                    }
                    
                    if let detail2 = data.detail2 {
                        HStack(spacing: 4) {
                            Text(detail2.label)
                                .foregroundColor(AppColors.text)
                            
                            Text(detail2.value)
                                .foregroundColor(AppColors.heading)
                        }
                        .font(.system(size: 12))
                    }
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.border, lineWidth: 2)
        )
    }
}
