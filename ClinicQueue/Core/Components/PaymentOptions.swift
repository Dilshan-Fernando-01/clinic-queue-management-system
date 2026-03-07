//
//  PaymentOptions.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI

struct PaymentOptions: View {
    let items: [CheckboxItem]
    @Binding var selectedKey: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Option")
                .font(.system(size: 20, weight: .bold))
            
            ForEach(items) { item in
                Button(action: {
                    selectedKey = item.key
                }) {
                    HStack {
                        Text(item.label)
                            .foregroundColor(selectedKey == item.key ? .white : .black)
                        Spacer()
                        ZStack {
                            Circle()
                                .stroke(selectedKey == item.key ? Color("157979") : Color.black, lineWidth: 2)
                                .frame(width: 18, height: 18)
                            if selectedKey == item.key {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    .padding(12)
                    .background(selectedKey == item.key ? Color("169A8F") : Color.white)
                    .cornerRadius(10)
                }
            }
        }
    }
}
