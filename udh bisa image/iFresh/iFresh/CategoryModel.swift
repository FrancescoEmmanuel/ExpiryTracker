//
//  CategoryModel.swift
//  iFresh
//
//  Created by Gladys Lionardi on 28/03/25.
//

import Foundation

struct CategoryModel {
    var itemName: String
    var qty: Int
    var imgName: String
    
    static func generateCategoryModel() -> [CategoryModel]{
        return [
            CategoryModel(itemName: "Nu Green Tea Original", qty: 12, imgName: "nuGreenTea"),
            CategoryModel(itemName: "Ultra Milk Low Fat", qty: 12, imgName: "uMilkLowFat"),
            CategoryModel(itemName: "Teh Botol Kotak 330ml", qty: 8, imgName: "tehBotol330"),
            CategoryModel(itemName: "Chiki Keju", qty: 22, imgName: "chikiBallsCheese")
        ]
    }
}
