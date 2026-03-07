//
//  RoundCheckboxGroup.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI


struct RoundCheckboxGroup: View {

    let items: [CheckboxItem]
    @Binding var selectedKeys: Set<String>

    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in

                Button {
                    toggleSelection(item.key)
                } label: {

                    HStack {
                        
                        Text(item.label)
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        ZStack {
                            
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 15, height: 15)
                            
                            if selectedKeys.contains(item.key) {
                                Circle()
                                    .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 1)
                                    .frame(width: 15, height: 15)
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(
                        selectedKeys.contains(item.key)
                        ? Color(red: 205/255, green: 249/255, blue: 246/255)
                        : Color(red: 244/255, green: 247/255, blue: 247/255)
                    )
                    .cornerRadius(10)
                }
            }
        }
    }

    private func toggleSelection(_ key: String) {
        if selectedKeys.contains(key) {
            selectedKeys.remove(key)
        } else {
            selectedKeys.insert(key)
        }
    }
}
