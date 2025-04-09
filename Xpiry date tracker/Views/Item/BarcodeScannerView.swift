//
//  BarcodeScannerView.swift
//  Xpiry date tracker
//
//  Created by Francesco on 09/04/25.
//

import Foundation
import SwiftUI
import VisionKit



struct BarcodeScannerView: View {
    
    @EnvironmentObject var barcodeVm: BarcodeScannerViewModel
    
    var body: some View {
        switch barcodeVm.dataScannerAccessStatus {
        case .scannerAvailable:
            Text("Scanner is available.")
        
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
}
