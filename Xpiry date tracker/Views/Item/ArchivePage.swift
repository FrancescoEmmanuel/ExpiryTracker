//
//  ArchivePage.swift
//  Xpiry date tracker
//
//  Created by Francesco on 06/04/25.
//

import SwiftUI

struct ArchivePage: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var vm: CoreDataVM
    @StateObject private var viewModel = ViewModel()

    @State private var selectedItems: Set<UUID> = []
    @State private var showDeleteAlert: Bool = false
    
    let sectionPriority: [String: Int] = [
        "PAST DUE": 0,
        "DUE TOMORROW": 1,
        "DUE IN 2 DAYS": 2,
        "DUE IN 3 DAYS": 3,
        "DUE IN 4 DAYS": 4,
        "DUE IN 5 DAYS": 5,
        "DUE IN 6 DAYS": 6,
        "DUE IN 7 DAYS": 7,
        "FAR FROM DUE": 8
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                    
                        
                        if vm.items.filter({ $0.archived }).isEmpty {
                            Text("No archived items found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 142)
                                .padding(.vertical, 250)
                        } else {
                            let archivedItems = vm.items.filter { $0.archived }
                            let grouped = groupItemsByExpiry(archivedItems)
                            let orderedSections = grouped.keys.sorted {
                                (sectionPriority[$0] ?? Int.max) < (sectionPriority[$1] ?? Int.max)
                            }
                            
                            VStack(spacing: 0) {
                                ForEach(orderedSections, id: \.self) { section in
                                    if let itemsInSection = grouped[section], !itemsInSection.isEmpty {
                                        ItemSection(
                                            title: section,
                                            items: itemsInSection
                                        )
                                        .environmentObject(vm)
                                        .environmentObject(viewModel)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                }
                .navigationTitle("Archived")
                .toolbar{
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            viewModel.isEditing.toggle()
                            if !viewModel.isEditing {
                                selectedItems.removeAll()
                            }
                        } label:{
                            if !viewModel.isEditing {
                                Image(systemName: "square.and.pencil").foregroundColor(.black)
                            }else{
                                Text("Done").foregroundColor(Color.myGreen)
                            }
                            
                        }
                    }
                }
                .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .navigationBar)
                
                if viewModel.isEditing{
                    VStack{
                        Spacer()
                        HStack{
                            Button{
                                
                                viewModel.selectedItems.forEach { item in
                                    if let itemToArchive = vm.items.first(where: { $0.id == item }) {
                                        vm.toggleArchiveItem(itemToArchive)
                                    }
                                }
                                viewModel.selectedItems.removeAll()
                                
                                viewModel.isEditing.toggle()
                                
                            } label:{ Text("Unarchive")
                                
                                
                                
                            }.disabled(viewModel.selectedItems.isEmpty)
                            
                      
                            
                            Spacer()
                            
                            Button{
                                
                                showDeleteAlert = true
                                
                            } label:{ Text("Delete")}.disabled(viewModel.selectedItems.isEmpty).alert(isPresented: $showDeleteAlert) {
                                Alert(
                                    title: Text("Delete Items?"),
                                    message: Text("Are you sure you want to delete these items? They will be removed permanently from your list."),
                                    
                                    primaryButton: .destructive(Text("Delete")) {
                                        
                                        viewModel.selectedItems.forEach { item in
                                            if let itemToDelete = vm.items.first(where: { $0.id == item }) {
                                                vm.deleteItem(itemToDelete)
                                            }
                                        }
                                        viewModel.selectedItems.removeAll()
                                        
                                        viewModel.isEditing.toggle()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 15)
                        .foregroundColor(viewModel.selectedItems.isEmpty ? Color.gray : Color.myGreen)
                        .background(.ultraThinMaterial)
                        
                    }
                    
                }
                
            }
        }
    }
}

//#Preview {
//    ArchivePage().environment(\.managedObjectContext, PersistenceController().container.viewContext)
//}
