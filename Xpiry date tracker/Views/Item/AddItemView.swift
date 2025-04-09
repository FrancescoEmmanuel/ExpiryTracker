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
    
    @Binding var selectedCategory: CategoryEntity?
    @State private var showValidationSheet = false
    @State private var showErrorHandling = false
    @EnvironmentObject var vm: CoreDataVM
    
    @StateObject private var viewModel = ViewModel()
    

    
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
                        
                        guard !itemName.isEmpty || !quantity.isEmpty else {
                                showErrorHandling = true
                                return
                            }
                        
                        let name = itemName
                        let qty = Int64(Int(quantity) ?? 0)
                        let expDate = dueDate
                        let image = selectedImage
                        let category = selectedCategory
                        
                       
            
                        if category == nil {
                            vm.addItem(name: name, quantity: qty, exp: expDate, image: image)
                            
                        } else {
                            vm.addItem(name: name, quantity: qty, category: category, exp: expDate, image: image)
                        }
                        
                        dismiss()
                        viewModel.showAddModal = false
                        selectedCategory = nil
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
                ToolbarItem (placement: .principal) {
                    Text("Add Items")
                        .fontWeight(.semibold)
                }
                ToolbarItem (placement: .navigationBarLeading){
                    Button("Cancel") {
                        showValidationSheet = true
                    }.foregroundColor(Color.myGreen)
                }
            }
//            .navigationBarTitle(Text("Add Items") .fontWeight(.semibold))
//            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(.systemGroupedBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
                
            
        }
        .interactiveDismissDisabled(true)
        .alert("Please fill in all the fields.", isPresented: $showErrorHandling) {
                   Button("OK", role: .cancel) {
                       showErrorHandling = false
                   }
               }
        
        .sheet(isPresented: $showCategoryModal) {
            CategoryPage(selectedCategory: $selectedCategory)
            
        }.confirmationDialog("Discard changes?", isPresented: $showValidationSheet, titleVisibility: .visible) {
            
            Button("Discard Changes", role: .destructive) {
                dismiss()
                selectedCategory = nil
                viewModel.showAddModal = false
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
