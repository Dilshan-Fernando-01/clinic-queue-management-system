//
//  CategoryBoxGrid.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct CategoryBoxGrid: View {
    
    let item: CategoryItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        VStack(spacing: 6) {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AppColors.categoryHighlight : Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 4)
                    .frame(width: 63, height: 53)
                
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            Text(item.title)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? AppColors.primary : AppColors.text)
                .multilineTextAlignment(.center)
                .lineLimit(2) 
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 64)
        .onTapGesture {
            action()
        }
    }
}
