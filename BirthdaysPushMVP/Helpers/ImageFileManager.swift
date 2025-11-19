//
//  ImageFileManager.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 19.11.2025.
//

import Foundation
import UIKit

class ImageFileManager {
    
    static let shared = ImageFileManager()
    
    private let fileManager = FileManager.default
    private var directoryPath: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(_ data: Data, identifier: String) -> String {
        let imagePath = directoryPath.appendingPathComponent(identifier + ".png")

        do {
            try data.write(to: imagePath)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return imagePath.path()
    }
    
    func loadImage(_ imagePath: String) -> UIImage {
        guard let data = fileManager.contents(atPath: imagePath),
              let image = UIImage(data: data)
        else {
            return UIImage()
        }
        
        return image
    }
}
