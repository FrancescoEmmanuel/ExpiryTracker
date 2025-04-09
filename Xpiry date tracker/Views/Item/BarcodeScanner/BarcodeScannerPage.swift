//
//  BarcodeScannerView.swift
//  Xpiry date tracker
//
//  Created by Francesco on 09/04/25.
//

import Foundation
import SwiftUI
import VisionKit



struct BarcodeScannerPage: View {
    
    @EnvironmentObject var barcodeVm: BarcodeScannerViewModel
    
    var body: some View {
//        mainView
        switch barcodeVm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        
        case .cameraNotAvailable:
            Text("Camera not available.")
        
        case .scannerNotAvailable:
            Text("Your device does not support barcode scanning.")
            
        case .cameraAccessDenied:
            Text("Please provide access to the camera in your device settings.")
            
        case .notDetermined:
            Text("Requesting camera access...")
            
        }
        
        
    }
    
    private var mainView: some View {
        VStack(alignment: .center) {
            VStack(spacing: 15){
                Text("Scan Barcode").font(.system(size: 24, weight: .semibold))
                Text("Scan the barcode found on the product label to instantly access product name, expiration date, and more.").font(.system(size: 16, weight: .regular)).multilineTextAlignment(.center).lineSpacing(3)
                    .foregroundColor(Color.myGray)
                
            }.padding(.bottom,40)
                .padding(.top,30)
            
            VStack{
                BarcodeScannerView(recognizedItems: $barcodeVm.recognizedItems)
                    .cornerRadius(8)
                
            }.padding(.bottom,300)
                .padding(.horizontal, 10)
            
            VStack{
                
                if let item = barcodeVm.recognizedItems.first {
                    switch item {
                    case .barcode(let barcode):
                        Text(barcode.payloadStringValue ?? "Unknown barcode")
                            .font(.system(size: 16))
                        Button("Scan Again") {
                            barcodeVm.recognizedItems.removeAll()
                        }
                        .padding(.top, 10)
                        .buttonStyle(.borderedProminent)
                    default:
                        Text("Not a barcode")
                    }
                } 

            }
                
                
            
        }
        .background(.ultraThinMaterial)
        .padding(.vertical, 32)
        .padding(.horizontal, 15)
        
        
    }
}
#Preview {
    BarcodeScannerPage()
        .environmentObject(BarcodeScannerViewModel())
}
