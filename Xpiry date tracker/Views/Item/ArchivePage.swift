////
////  ArchivePage.swift
////  Xpiry date tracker
////
////  Created by Francesco on 06/04/25.
////
//
//import SwiftUI
//
//struct ArchivePage: View {
//    
//    var body: some View {
//        VStack {
//            
//            ScrollView {
//                LazyVStack() {
//                    if filteredItems.isEmpty {
//                        Text("No item found")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .padding(.top, 250)
//                    }else {
//                        
//                        ForEach(filteredItems, id: \.self) { item in
//                            ItemCard(item: item, vm: vm)
//                                .padding(.horizontal)
//                            Divider()
//                        }
//                    }
//                }
//            }.searchable(text: $searchText, prompt: "Search item").padding(.vertical)
//
//        }
//        .background(Color.white.opacity(0.5))
//        .toolbar{
//            HStack {
//                Text("Search")
//                    .font(.headline)
//            }.padding(.trailing, 160)
//
//        }
//    }
//}
