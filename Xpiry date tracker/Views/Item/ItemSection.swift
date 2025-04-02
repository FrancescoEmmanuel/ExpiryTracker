import SwiftUI

struct ItemSection: View {
    
    var title: String
    var color: Color
    @EnvironmentObject var viewModel: ViewModel
    
    
    
    var items: [ItemCard] = [
        ItemCard(imageName: "grapes", itemName: "Grapes", quantity: 30, expiry: "12/08/24"),
        ItemCard(imageName: "mango", itemName: "Mango", quantity: 20, expiry: "12/08/24")
    ]
    
    var body: some View {
        
        
        
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                
                if viewModel.isEditing {
                    Button(action: {
                        // Toggle selection for all items in the section
                        let allSelected = items.allSatisfy { viewModel.selectedItems.contains($0.itemName) }
                        if allSelected {
                            items.forEach { viewModel.selectedItems.remove($0.itemName) }
                        } else {
                            items.forEach { viewModel.selectedItems.insert($0.itemName) }
                        }
                    }) {
                        Image(systemName: items.allSatisfy { viewModel.selectedItems.contains($0.itemName) } ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.gray)
                            .frame(width: 24, height: 24)
                           
                    }
                }
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                    .padding(.vertical,13)
            } .padding(.leading,15)
            
            
            
            Divider()
            
            VStack(spacing:0){
                ForEach(Array(items.enumerated()), id: \.element.itemName) { index, item in
                    VStack(spacing:0){
                        HStack{
                            if viewModel.isEditing{
                                Button{
                                    if viewModel.selectedItems.contains(item.itemName){
                                        viewModel.selectedItems.remove(item.itemName)
                                    } else{
                                        viewModel.selectedItems.insert(item.itemName)
                                    }
                                    
                                } label:{ Image(systemName: viewModel.selectedItems.contains(item.itemName) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.gray)
                                        .frame(width: 24, height: 24)
                                    
                                }
                                
                            }
                            
                            ItemCard(
                                imageName: item.imageName,
                                itemName: item.itemName,
                                quantity: item.quantity,
                                expiry: item.expiry
                            )
                            
                        }
                       
                        
                        // Add Divider only if it's NOT the last item
                        
                        if index < items.count - 1 {
                            Divider()
                        }
                    }.padding(.leading,15)
                    
                }
            }
        
            
            
            
            
        }
        .background(Color.white.opacity(0.5))
        
        
        
        
        
    }
    
}


#Preview {
    ItemSection(title: "PAST DUE", color: Color.red).environmentObject(ViewModel())
}
