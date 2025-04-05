//
//  ItemCard.swift
//  Xpiry date tracker
//
//  Created by Francesco on 26/03/25.
//

import SwiftUI


struct ItemCard: View {
    
    let item: ItemEntity
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy" // Change format as needed
        return formatter
    }()

 
    
    @ObservedObject var vm: CoreDataVM
    
//    var imageName: String
//    var itemName: String
//    var quantity: Int
//    var expiry: String
//    
    
    var body: some View {
        
        
        
        VStack{
            
            HStack{
                Image("mango").resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading){
                    Text(item.name ?? "Undefined").font(.system(size:16, weight:.medium))
                    Text(String("Quantity: \(item.qty)")).font( .system(size:15 ,weight: .regular)).foregroundColor(.gray)
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
            
            
            
        }.swipeActions(edge: .trailing, allowsFullSwipe: true){
            Button{
                vm.deleteItem(item)
                print("delete")
            } label:{
                Image(systemName:"trash").tint(.myRed)
            }
            
            Button{
                print("archive")
                
            } label:{ Image(systemName:"bin.xmark.fill").tint(.myBlue) }
            
            
            
            
        }.enableSwipeAction()
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
