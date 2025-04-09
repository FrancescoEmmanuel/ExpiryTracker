//
//  BarcodeScannerView.swift
//  Xpiry date tracker
//
//  Created by Francesco on 09/04/25.
//

import Foundation
import SwiftUI
import VisionKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    
    @Binding var recognizedItems: [RecognizedItem]
//    let recognizesMultipleItems: Bool
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        let vc = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel:.balanced,
            recognizesMultipleItems: false,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        
        uiViewController.delegate = context.coordinator
        
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    class Coordinator: NSObject, DataScannerViewControllerDelegate{
        
        @Binding var recognizedItems: [RecognizedItem]
        
        init(recognizedItems: Binding<[RecognizedItem]>) {
            self._recognizedItems = recognizedItems
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            guard case let .barcode(barcode) = item else { return }

            // Save the tapped barcode to the recognizedItems list
            recognizedItems = [item] // Overwrite with the tapped one

            dataScanner.stopScanning()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            print("Tapped barcode with value: \(barcode.payloadStringValue ?? "nil")")
        }

        
//        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            guard recognizedItems.isEmpty else { return } // Only allow the first recognized item
//
//            if let firstItem = addedItems.first {
//                recognizedItems = [firstItem]
//                dataScanner.stopScanning() // Stop scanning after recognizing the first item
//                UINotificationFeedbackGenerator().notificationOccurred(.success)
//                print("added item: \(firstItem)")
//            }
//        }

        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recognizedItems = recognizedItems.filter { item in !removedItems.contains(where: { $0.id == item.id })
            }
            print("removed items: \(removedItems)")
        
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("error: \(error)")
        }
    }

}
