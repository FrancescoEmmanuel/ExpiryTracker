//
//  Xpiry_date_trackerApp.swift
//  Xpiry date tracker
//
//  Created by Francesco on 26/03/25.
//

import SwiftUI


@main
struct Xpiry_date_trackerApp: App {
    

   

    init() {
        NotifManager.instance.requestAuthorization()
    }

    @StateObject private var barcodeVm = BarcodeScannerViewModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .task{
                    await barcodeVm.requestDataScannerAccessStatus()
                }
                .environmentObject(barcodeVm)
        }
    }
}


