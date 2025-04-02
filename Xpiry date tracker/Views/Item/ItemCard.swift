//
//  ItemCard.swift
//  Xpiry date tracker
//
//  Created by Francesco on 26/03/25.
//

import SwiftUI


struct ItemCard: View {
    
    var imageName: String
    var itemName: String
    var quantity: Int
    var expiry: String
    
    
    var body: some View {
        
        
        
        VStack{
            
            HStack{
                Image(imageName).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading){
                    Text(itemName).font(.system(size:16, weight:.medium))
                    Text(String("Quantity: \(quantity)")).font( .system(size:15 ,weight: .regular)).foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("ED").font(.system(size:14 ,weight:.light))
                    Text(expiry).font(.system(size:14 ,weight:.regular))
                }
                
                .foregroundColor(.gray)
                
                
            }
            .padding(.vertical, 13)
            .padding(.trailing,15)
            
            
            
        }.swipeActions(edge: .trailing, allowsFullSwipe: true){
            Button{
                
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
    ItemCard(imageName:"grapes", itemName:"Grapes", quantity:20, expiry:"25/03/25")
}
