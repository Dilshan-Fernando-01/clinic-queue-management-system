//
//  CategoryGrid.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//
import SwiftUI

struct CategoryGrid: View {
    
    let items: [CategoryItem]
    
    @State private var selectedItems: Set<UUID> = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 20) {
            
            ForEach(items) { item in
                
                CategoryBoxGrid(
                    item: item,
                    isSelected: selectedItems.contains(item.id),
                    action: {
                        if selectedItems.contains(item.id) {
                            selectedItems.remove(item.id)
                        } else {
                            selectedItems.insert(item.id)
                        }
                    }
                )
            }
        }
    }
}
