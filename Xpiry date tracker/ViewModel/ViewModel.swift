//
//  ViewModel.swift
//  Xpiry date tracker
//
//  Created by Francesco on 01/04/25.
//


import SwiftUI


class ViewModel: ObservableObject {
    @Published var isEditing = false
    @Published var selectedItems: Set<UUID> = []
    @Published var sections = []
}
