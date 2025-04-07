//
//  ContentView.swift
//  AddItem
//
//  Created by Claurent Virginie on 04/04/25.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    @State private var itemName: String = ""
    @State private var quantity: String = ""
    @State private var category: String = "Uncategorized"
    @State private var dueDate: Date = Date()
    
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 8) {
                Image("kiwi")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .scaledToFit()
                    .cornerRadius(8)
                    .padding (.top, 10)
                Button("Add Photo"){}
                    .foregroundColor(.accentGreen)
                    .padding(.bottom, 32)
                VStack (spacing: 16) {
                    VStack {
                        HStack {
                            Text("Name")
                                .frame(width: 100, alignment: .leading)
                            TextField("Item Name", text: $itemName)
                                .multilineTextAlignment(.leading)
                            .foregroundColor(.gray)}
                        Divider()
                        HStack {
                            Text("Quantity")
                                .frame(width: 100, alignment: .leading)
                            Spacer ()
                            TextField("Quantity", text: $quantity)
                                .keyboardType(.numberPad)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    VStack {
                        HStack {
                            Text("Category")
                            Spacer ()
                            Text(category)
                                .foregroundColor(.gray)
                        }
                        Divider()
                        HStack {
                            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .accentColor(.accentGreen)
                        }}
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    Spacer()
                    Button("Done") {}
                        .foregroundColor(.accentGreen)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
            .frame(alignment: .center)
            .background(Color(.systemGroupedBackground))
            .toolbar{
                //                ToolbarItem (placement: .principal) {
                //                    Text("Add Items")
                //                }
                ToolbarItem (placement: .navigationBarLeading){
                    Button("Cancel") {}.foregroundColor(.accentGreen)
                }
            }
            .navigationBarTitle(Text("Add Items") .fontWeight(.semibold))
            .navigationBarTitleDisplayMode(.inline)
                
                
                
            
        }
    }
}
// Preview
struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
