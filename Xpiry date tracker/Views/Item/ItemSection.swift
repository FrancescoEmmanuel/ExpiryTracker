import SwiftUI

struct ItemSection: View {
    
    var title: String
    var items: [ItemEntity]
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var vm: CoreDataVM
    
    
    @State private var showEditModal: Bool = false
    @State private var selectedItem: ItemEntity? = nil
    
    @State private var selectedCategory: CategoryEntity? = nil

    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0) {
            
            
            headerView
            Divider()
            itemList
            
            
        }
        .background(Color.white.opacity(0.5))
        
        
        
        
        
    }
    
    private var headerView : some View {
        
        HStack{
            if viewModel.isEditing {
                Button(action: {
                    // Toggle selection for all items in the section
                    let allSelected = items.allSatisfy { viewModel.selectedItems.contains($0.id ?? UUID()) }
                    if allSelected {
                        items.forEach { viewModel.selectedItems.remove($0.id ?? UUID()) }
                    } else {
                        items.forEach { viewModel.selectedItems.insert($0.id ?? UUID()) }
                    }
                }) {
                    Image(systemName: items.allSatisfy { viewModel.selectedItems.contains($0.id ?? UUID()) } ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                    
                }
            }
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(determineColor(title: title))
                .padding(.vertical,13)
            
        }.padding(.leading,15)
        
        
        
        
    }
    
    private var itemList: some View {
        ForEach(items, id: \.self) { item in
            itemRow(for: item)
            
        }
    }
    
    private func itemRow(for item: ItemEntity) -> some View {
        VStack(spacing:0){
            HStack{
                if viewModel.isEditing{
                    Button{
                        if viewModel.selectedItems.contains(item.id ?? UUID()){
                            viewModel.selectedItems.remove(item.id ?? UUID())
                        } else{
                            viewModel.selectedItems.insert(item.id ?? UUID())
                        }
                        
                    } label:{ Image(systemName: viewModel.selectedItems.contains(item.id ?? UUID()) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.gray)
                            .frame(width: 24, height: 24)
                        
                    }
                    
                }
                
                ItemCard(
                    
                    item: item,
                    vm:vm
                ).onTapGesture {
                    
                        selectedItem = item
                        selectedCategory = item.categorygrouping
                        showEditModal = true
                    
                }

                
            }
            
            // Add Divider only if it's NOT the last item
            
            if !isLastItem(item){
                Divider()
            }
            
        }
        .padding(.leading,15)
        .sheet(isPresented: $showEditModal) {
            EditItemView(
                selectedCategory: $selectedCategory,
                itemToEdit: $selectedItem
            )
            .environmentObject(vm)
//            .presentationDetents([.medium, .large])
//            .presentationDragIndicator(.visible)
        }

    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    private func isLastItem(_ item: ItemEntity) -> Bool {
        guard let index = vm.items.firstIndex(of: item) else { return false }
        return index == vm.items.count - 1
    }
    
    private func determineColor(title : String) -> Color {
    
        switch title {
            case "Expired": return Color.red
            case "Expiring Tomorrow": return Color.orange
    
        default:
            return Color.green
        }
    }
    
    
    
    
    
    
}


//#Preview {
//    ItemSection(title: "PAST DUE", color: Color.red).environmentObject(ViewModel()).environmentObject(vm())
//}
