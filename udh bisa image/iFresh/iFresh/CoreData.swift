//
//  CoreData.swift
//  iFresh
//
//  Created by Gladys Lionardi on 31/03/25.
//

import SwiftUI
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init(){
        container = NSPersistentContainer(name: "ItemContainer")
        container.loadPersistentStores{
            (_, error) in
            if let error = error {
                print("Error in loading core data. \(error)") // debugging. most likely error in container name
            } else {
                print("sucessfully loaded core data.") // debugging. look at terminal.
            }
        }
        context = container.viewContext
    }
    
    func saveData(){
        do{
            try context.save()
//            fetchItems() // we need to update published var everytime we save (biar UI ganti) jd panggil fetch func lagi bcs when we call this func, it'll call a fetch request and put it into the published var
            print("saved successfully")
        } catch let error {
            print("error saving core data. \(error)") //debugging.
        }
    }
    
    func delete(_ object: NSManagedObject){
        context.delete(object)
        saveData()
    }
}

class CoreDataVM: ObservableObject {
    
    let manager = CoreDataManager.instance
    @Published var items: [ItemEntity] = []
    @Published var categories: [CategoryEntity] = []
    
    init(){
        getItem()
        getCategory()
    }
    
    func getItem(){
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        do{
            items = try manager.context.fetch(request)
        } catch let error {
            print("error fetching items. \(error)")
        }
    }
    
    func getCategory(){
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        
        // sort ascending by default
        let sort = NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)
        request.sortDescriptors = [sort]
        
//        // filtering
//        let filter = NSPredicate(format: "name == %@", "")
//        request.predicate = filter
        
        do{
            categories = try manager.context.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
    }
    
    func getCategoryImage(category: CategoryEntity) -> UIImage? {
        guard let imageName = category.imgName else {return nil}
        return LocalFileManager.instance.getImage(name: imageName)
    }
    
    private func getDefaultCategory() -> CategoryEntity {
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        request.predicate = NSPredicate(format: "name == %@", "Uncategorised")
        
        if let existingCategory = try? manager.context.fetch(request).first{
            return existingCategory
        } else {
            let newCategory = CategoryEntity(context: manager.context)
            newCategory.name = "Uncategorised"
            saveData()
            return newCategory
        }
    }
    
    
    func addItem(name: String, quantity: Int64, category: CategoryEntity?=nil) {
        let newItem = ItemEntity(context: manager.context)
        newItem.name = name
        newItem.qty = quantity
        // categorygrouping is not an attribute of item, kita ga perlu define sbg attribute. meski item ada categorynya, kita ga harus define as attribute, krn category entity ud didefine relationshipnya sama item.
        newItem.categorygrouping = category ?? getDefaultCategory() // klo kosong catnya ywd getdefault (uncategorised)
        saveData()
    }
    
    func addCategory(name: String, image: UIImage?){
        let newCategory = CategoryEntity(context: manager.context)
        newCategory.name = name
        // adding items
//        newCategory.items = [items]
//        newCategory.addToItems(item[0]) -> second way
        if let image = image {
            let imageName = UUID().uuidString
            LocalFileManager.instance.saveImg(image: image, name: imageName)
            newCategory.imgName = imageName
        }
        saveData()
    }
    
    func updateItem(entity: ItemEntity, newName: String?=nil, newQty: Int64?=nil){
        if let updatedName = newName {
            entity.name = updatedName // update klo ada input new name
        }
        if let updatedQty = newQty{
            entity.qty = updatedQty
        }
        saveData()
    }
    
    func updateCategory(category: CategoryEntity, newName: String){
        category.name = newName
        saveData()
    }
    
    func deleteItem(_ item: ItemEntity){
        manager.context.delete(item)
        saveData()
    }
    
    // klo mau pas panggil function ga nulis deleteItem(item:..) bisa pke code func deleteItem(_ item: ItemEntity). klo ada _ di depan -> pas manggil function tinggal deleteItem(barangnyaapa). pke klo ud jelas yg lu mau pass data apa
    
    func deleteCategory(_ category: CategoryEntity){
        if let imageName = category.imgName{
            LocalFileManager.instance.deleteImage(name: imageName)
        }
        manager.context.delete(category)
        saveData()
    }
    
    func saveData(){
        manager.saveData()
        getItem()
        getCategory()
    }
    
    
    
}
