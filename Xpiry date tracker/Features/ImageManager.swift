//
//  ImageManager.swift
//  Created by Gladys Lionardi on 01/04/25.
//

import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    let folderName = "iFresh"
    
    init(){
        createFolder()
    }
    
    func createFolder(){
        
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName).path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            do{
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("successfully created folder.")
            } catch let error {
                print("error creating folder. \(error)")
            }
        }
            
    }
    
    func deleteFolder(){
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName).path else {
            return
        }
        do{
            try FileManager.default.removeItem(atPath: path)
            print("successfully deleted folder.")
        } catch let error {
            print("error deleting folder. \(error)")
        }
    }
    
    func saveImg(image: UIImage, name: String){
        
        guard
            let data = image.jpegData(compressionQuality: 1.0),
            let path = getPathForImage(name: name)
        else {
            print("error getting data") // debugging. look at terminal
            return
        }
        
        do {
            try data.write(to: path)
            print("successfully saved")
        } catch let error {
            print("error saving. \(error)")
        }
        
    }
    
    func getImage(name: String) -> UIImage? {
        
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("error getting path.")
            return nil
        }
        return UIImage(contentsOfFile: path)
        
    }
    
    func deleteImage(name: String) {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("error getting path.")
            return
        }
        do{
            try FileManager.default.removeItem(atPath: path)
            print("successfully deleted")
        } catch let error {
            print("error deleting image. \(error)")
        }
    }
    
    func getPathForImage(name: String) -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(folderName)
            .appendingPathComponent("\(name).jpg") else {
            print("error getting data")
            return nil
        }
        return path
    }
    
}

class FileManagerVM: ObservableObject {
    
    @Published var image: UIImage? = nil
    let imageName: String = ""
    let manager = LocalFileManager.instance
    
    init(){
        getImageFromFileManager()
    }
    
    func getImageFromFileManager(){
        image = manager.getImage(name: imageName)
    }
    
    func saveImage(){
        guard let image = image else {return}
        manager.saveImg(image: image, name: imageName)
    }
    
    func deleteImage(){
        manager.deleteImage(name: imageName)
    }
}

