//
//  PaymentThroughCashView.swift
//  ClinicQueue
//
//  Created by dilshan fernando on 2026-03-08.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct PaymentThroughCashView: View {
    
    @State private var navigateToStatus = false
    private let paymentSuccess = true
    
    private let patientName = "John Doe"
    private let billingId = "B12345"
    private let amount = "$70.00"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Pay at Counter")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    
                    Text("Please present this QR code at the payment counter to complete your payment.")
                        .foregroundColor(AppColors.lableColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, Spacing.section).multilineTextAlignment(.center)
                    
                    Text("Our staff will scan the code and assist you.")
                        .foregroundColor(AppColors.lableColor)
                        .frame(maxWidth: .infinity, alignment: .center).multilineTextAlignment(.center)
                    
                    if let qrImage = generateQRCode() {
                        Image(uiImage: qrImage)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, Spacing.section)
                    }
                    
                    Text("\(patientName) | \(billingId) | \(amount)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
    }
    
    private func generateQRCode() -> UIImage? {
        let dataString = "\(patientName)|\(billingId)|\(amount)"
        let data = Data(dataString.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

#Preview {
    NavigationStack {
        PaymentThroughCashView()
    }
}
