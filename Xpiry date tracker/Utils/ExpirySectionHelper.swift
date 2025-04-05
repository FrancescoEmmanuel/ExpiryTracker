//
//  ExpirySectionHelper.swift
//  Xpiry date tracker
//
//  Created by Francesco on 04/04/25.
//
import Foundation

struct ExpirySection {
    let title: String
    let items: [ItemEntity]
}

func groupItemsByExpiry(_ items: [ItemEntity]) -> [String: [ItemEntity]] {
    var sectionedItems: [String: [ItemEntity]] = [:]
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    for item in items {
        guard let expiry = item.exp else {
            sectionedItems["No Expiry Date", default: []].append(item)
            continue
        }
        
        let expiryDay = calendar.startOfDay(for: expiry)
        let components = calendar.dateComponents([.day], from: today, to: expiryDay)
        guard let daysLeft = components.day else { continue }
        
        let section: String
        
        if daysLeft <= 0 {
            section = "Expired"
        } else if daysLeft == 1 {
            section = "Expiring Tomorrow"
        } else if daysLeft <= 7 {
            section = "Expiring in \(daysLeft) Days"
        } else {
            section = "Expiring Later"
        }
        
        sectionedItems[section, default: []].append(item)
    }
    
    return sectionedItems
}

