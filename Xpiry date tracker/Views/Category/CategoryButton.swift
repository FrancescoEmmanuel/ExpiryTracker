//
//  CategoryButton.swift
//  Xpiry date tracker
//
//  Created by Francesco on 27/03/25.
//



import SwiftUI

struct CategoryButton: View {

//    @State var selectedCategory: String?
    
    var label: String
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal){
            
            HStack{
                
                Button(action: {
                    
                    selectedCategory = label
                  
                }) {
                    Text(label)
                        .font(.system(size:16))
                        .foregroundColor(selectedCategory == label ? Color.white : Color.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedCategory == label ? Color.buttonGray : Color.white.opacity(0.5)
                            
                        )
                     
                        .cornerRadius(40)
                        .frame(height:34)
                        .clipShape(.capsule)
                }
                
                
            }.padding(.bottom, 10)
            
        }
    }
}


#Preview {
//    CategoryButton(label:"Test", selectedCategory: "Test")
}
