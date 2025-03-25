//
//  ContentView.swift
//  sewaCat
//
//  Created by Francesco on 24/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText = ""
    @State private var selectedFilters: [String: String] = [:]
    @State private var showFilterSheet = false
    
    private var cats: [petCard] = [
        petCard(name: "Leppy", imageName: "Leppy", catType: "Domestic", weight: 5.0),
        petCard(name: "Butet", imageName: "Butet", catType: "Domestic", weight: 2.3),
        petCard(name: "Kentang", imageName: "Kentang", catType: "Domestic", weight: 3.6),
        petCard(name: "Sky", imageName: "Sky", catType: "Domestic", weight: 8.2 )
    ]
    
    var filteredCats: [petCard] {
        cats.filter { cat in
            // Apply search filter
            (searchText.isEmpty || cat.name.localizedCaseInsensitiveContains(searchText)) &&
            (selectedFilters["Weight"] == nil ||
             (Float(selectedFilters["Weight"]!) ?? 10.0) >= cat.weight)
        }
    }
    
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                VStack(spacing: 15){
                    ForEach(filteredCats, id: \.name){ cat in
                        NavigationLink(destination: DetailView()){ petCard(name: cat.name, imageName: cat.imageName, catType: cat.catType,
                                                                           weight: cat.weight)}
                    }
                }
                .padding(.horizontal, 13)
                .padding(.vertical, 10)
                .navigationBarTitle("Discover")
                .searchable(text: $searchText, prompt: "Search for a cat")
                .toolbar{
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(.orange)
                    }
                    
                }
                .sheet(isPresented: $showFilterSheet) {
                    FilterView(selectedFilters: $selectedFilters)
                }
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
