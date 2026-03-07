//
//  InputField.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-02-08.
//
import SwiftUI

struct InputField: View {

    var placeholder: String
    var placeholderColor: Color = AppColors.placeholder
    var backgroundColor: Color = .clear
    var textColor: Color = AppColors.text
    var borderRadius: CGFloat = 100
    var borderWidth: CGFloat = 1
    var borderColor: Color = AppColors.border
    var padding: CGFloat = 12

    @Binding var value: String

    var body: some View {
        TextField(placeholder, text: $value)
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: borderRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .padding(.horizontal)
    }
}
