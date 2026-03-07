//
//  CustomDropdown.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-07.
//

import SwiftUI



struct CustomDropdown: View {

    var placeholder: String
    var options: [DropdownOption]

    @Binding var selectedKey: String?

    var borderRadius: CGFloat = 100
    var borderWidth: CGFloat = 1
    var borderColor: Color = AppColors.border
    var padding: CGFloat = 12

    @State private var isOpen = false

    var body: some View {

        VStack(spacing: 0) {

            Button {
                withAnimation {
                    isOpen.toggle()
                }
            } label: {

                HStack {

                    Text(selectedLabel ?? placeholder)
                        .foregroundColor(selectedKey == nil ? AppColors.placeholder : AppColors.text)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
                .padding(padding)
                .overlay(
                    RoundedRectangle(cornerRadius: borderRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            }

            if isOpen {
                VStack(spacing: 0) {

                    ForEach(options) { option in

                        Button {
                            selectedKey = option.key
                            isOpen = false
                        } label: {

                            HStack {
                                Text(option.label)
                                    .foregroundColor(AppColors.text)

                                Spacer()
                            }
                            .padding(padding)
                        }

                        if option.id != options.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 1)
                )
            }
        }
        .padding(.horizontal)
    }

    private var selectedLabel: String? {
        options.first { $0.key == selectedKey }?.label
    }
}
