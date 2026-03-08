//
//  CardInfoForm.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI

struct CardInfoForm: View {
    
    @Binding var nameOnCard: String
    @Binding var cardNumber: String
    @Binding var cvv: String
    @Binding var expirationDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Card Info")
                .font(.system(size: 20, weight: .bold))
            

            InputField(
                placeholder: "Name on the Card",
                value: $nameOnCard
            )
            
   
            InputField(
                placeholder: "Card Number",
                value: $cardNumber
            )
            

            HStack(spacing: 8) {
                InputField(
                    placeholder: "CVV",
                    value: $cvv
                )
                .frame(width: UIScreen.main.bounds.width * 0.35)
                
                InputField(
                    placeholder: "Expiration Date (YY/MM)",
                    value: $expirationDate
                )
                .frame(width: UIScreen.main.bounds.width * 0.60)
            }
        }
        .padding(.horizontal)
    }
}


struct CardInfoForm_Previews: PreviewProvider {
    @State static var name = ""
    @State static var number = ""
    @State static var cvv = ""
    @State static var exp = ""
    
    static var previews: some View {
        CardInfoForm(
            nameOnCard: $name,
            cardNumber: $number,
            cvv: $cvv,
            expirationDate: $exp
        )
        .previewLayout(.sizeThatFits)
    }
}
