//
//  BarcodeScanner.swift
//  Xpiry date tracker
//
//  Created by Francesco on 09/04/25.
//
import AVKit
import Foundation
import SwiftUI
import VisionKit

enum DataScannerAccessStatusType{
    case notDetermined
    case cameraAccessDenied
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class BarcodeScannerViewModel: ObservableObject {
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    func requestDataScannerAccessStatus() async{
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessDenied
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted{
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            }
            else {
                
                dataScannerAccessStatus = .cameraAccessDenied
                
            }
            
        default: break
            
        }
        
    }
}
