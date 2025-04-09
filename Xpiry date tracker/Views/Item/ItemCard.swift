//
//  ItemCard.swift
//  Xpiry date tracker
//
//  Created by Francesco on 26/03/25.
//

import SwiftUI


struct ItemCard: View {
    
    let item: ItemEntity
    
    let fileManager = LocalFileManager.instance
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy" // Change format as needed
        return formatter
    }()
    
   
    
    @State private var isEditingItem = false
    @State private var showDeleteAlert: Bool = false
 
    
    @ObservedObject var vm: CoreDataVM
    
//    var imageName: String
//    var itemName: String
//    var quantity: Int
//    var expiry: String
//    
    
    var body: some View {
        
        
        
        VStack{
            
            HStack{
                
                if let name = item.imgName, let image = fileManager.getImage(name: name) {
                                   Image(uiImage: image)
                                       .resizable()
                                       .aspectRatio(contentMode: .fill)
                                       .frame(width: 44, height: 44)
                                       .clipShape(RoundedRectangle(cornerRadius: 8))
                               } else {
                                   Image(systemName: "photo.fill")
                                       .resizable()
                                       .scaleEffect(0.6)
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 44, height: 44)
                                       .foregroundColor(.gray)
                                       .clipShape(RoundedRectangle(cornerRadius: 8))
                                       .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                               }
                
                VStack(alignment: .leading){
                    Text(item.name ?? "Undefåined").font(.system(size:16, weight:.medium))
                    Text(String("\(item.qty)")).font( .system(size:15 ,weight: .regular)).foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("ED").font(.system(size:14 ,weight:.light))
                    
                    Text(item.exp.map { dateFormatter.string(from: $0) } ?? "No Date").font(.system(size:14 ,weight:.regular))

                }
                
                .foregroundColor(.gray)
                
                
            }
            .padding(.vertical, 13)
            .padding(.trailing,15)
            
            
            
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true){
            Button{
                showDeleteAlert.toggle()
              
                
            } label:{
                Image(systemName:"trash").tint(.myRed)
            }
            
            Button{
                print("archive")
                
            } label:{ Image(systemName:"bin.xmark.fill").tint(.myBlue) }
            
            
            
            
        }.enableSwipeAction()
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Delete Item?"), message: Text("Are you sure you want to delete this item? It will be removed permanently from your list."), primaryButton: .destructive(Text("Delete")){
                    vm.deleteItem(item)
                }, secondaryButton: .cancel())
            }
    }
        
        
    }
    
    
    
    


#Preview {
  
    let context = PersistenceController.shared.container.viewContext
    

    let sampleItem = ItemEntity(context: context)
    sampleItem.name = "Grapes"
    sampleItem.qty = 20
    sampleItem.exp = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 25)) // 
    
    return ItemCard(item: sampleItem, vm: CoreDataVM())
    
    
}
