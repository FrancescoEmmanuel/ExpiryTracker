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
   
    @State private var dueDate: Date = Date()
    @State private var selectedImage: UIImage? = nil
    
    @State private var showDatePickerSheet = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCategoryModal = false
    
    @Binding var showAddModal : Bool
    @Binding var selectedCategory: CategoryEntity?
    @State private var showValidationSheet = false
    @EnvironmentObject var vm: CoreDataVM


    
    let fileManager = LocalFileManager.instance
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 8) {
                ImagePicker(selectedImage: $selectedImage, displayText: "Add Photo").padding(.bottom, 32)
//                Image("kiwi")
//                    .resizable()
//                    .frame(width: 140, height: 140)
//                    .scaledToFit()
//                    .cornerRadius(8)
//                    .padding (.top, 10)
//                Button("Add Photo"){}
//                    .foregroundColor(Color.myGreen)
//                    .padding(.bottom, 32)
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
                                .onChange(of: quantity) {
                                    // Keep only numeric characters
                                    quantity = quantity.filter { $0.isNumber }
                                }

                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    VStack {
                        HStack {
                            Text("Category")
                            Spacer ()
                            Button{
                                showCategoryModal.toggle()
                            }label:{
                                Text(selectedCategory?.name ?? "Uncategorized")
                                    .foregroundColor(.gray)
                                
                            }
                            
                        }
                        Divider()
                        HStack {
                            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .accentColor(Color.myGreen)
                        }}
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    Spacer()
                    Button("Done") {
                        
                            if selectedCategory == nil {
                                vm.addItem(
                                    name: itemName,
                                    quantity: Int64(Int(quantity) ?? 0),
                                    exp: dueDate,
                                    image: selectedImage
                                )
                                
                            }else{
                                vm.addItem(
                                    name: itemName,
                                    quantity: Int64(Int(quantity) ?? 0),
                                    category: selectedCategory,
                                    exp: dueDate,
                                    image: selectedImage
                                )
                                
                                
                                
                               
                            }
                        
                        dismiss()


                        
                    }
                        .foregroundColor(Color.myGreen)
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
                    Button("Cancel") {showValidationSheet = true}.foregroundColor(Color.myGreen)
                }
            }
            .navigationBarTitle(Text("Add Items") .fontWeight(.semibold))
            .navigationBarTitleDisplayMode(.inline)
                
                
                
            
        }.sheet(isPresented: $showCategoryModal) {
            CategoryPage(showAddModal: $showAddModal, selectedCategory: $selectedCategory)
            
        }.confirmationDialog("Discard changes?", isPresented: $showValidationSheet, titleVisibility: .visible) {
            
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }

            Button("Keep Editing", role: .cancel) {
                // do nothing, just dismiss the dialog
            }.foregroundColor(Color.myGreen)
        }
    }
}
// Preview
//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView()
//    }
//}
