//
//  DrugCard.swift
//  ClinicQueue
//
//  Created by Roshan on 2026-03-12.
//



import SwiftUI

struct DrugCard: View {
    let drug: Drug
    @State private var addedToCart = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(drug.color.opacity(0.12))
                    .frame(height: 110)

                Image(systemName: drug.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(drug.color)
            }
            .padding(.bottom, 10)

            Text(drug.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(2)

            Text(drug.subtitle)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.top, 2)

            HStack {
                Text(String(format: "$%.2f", drug.price))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        addedToCart = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { addedToCart = false }
                    }
                } label: {
                    Image(systemName: addedToCart ? "checkmark" : "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(addedToCart ? Color.green : Color(hex: "1A2E44"))
                        .cornerRadius(6)
                }
            }
            .padding(.top, 8)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}
