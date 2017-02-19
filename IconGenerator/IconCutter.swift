//
//  IconCutter.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

fileprivate let baseIconPathKey = "-p"
fileprivate let configPathKey = "-c"
fileprivate let outputPathKey = "-o"

fileprivate let baseIconDescription = "path to original image"
fileprivate let configPathDescription = "path to custom .json template for generate icons"
fileprivate let outputPathDescription = "path for output .xcassets"


let resultXcasset = "TestIcon.xcassets"
let resultIconSet = "AppIcon.appiconset"
let defaultTemplateName = "template.json"
let defaultOutput = "./"

struct IconCutter: Submodule {
    func process(_ arguments: [String]) {
        self.baseCheckInput(arguments)
        
        let utiliteArguments = self.mapInputArguments(arguments)
        
        let baseIconUrl = self.checkRequiredInput(for: baseIconPathKey,
                                                  in: utiliteArguments)
        
        guard let image = NSImage.init(contentsOfFile: baseIconUrl) else {
            print("Cannot open image")
            exit(EX_USAGE)
        }
        
        let outputPath = utiliteArguments[outputPathKey] ?? defaultOutput
        
        var parsedItems = [IconItem]()
        
        if let configPath = utiliteArguments[configPathKey] {
            let jsonURL = URL.init(fileURLWithPath: configPath)
            
            guard let configData = try? Data.init(contentsOf: jsonURL) else {
                print("Error read config file")
                exit(EX_USAGE)
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: configData, options: []) else {
                print("Error deserialization config file")
                exit(EX_USAGE)
            }
            
            guard let configValues = json as? [[String: String]] else {
                print("Error parse config file")
                exit(EX_USAGE)
            }
            
            for configItem in configValues {
                parsedItems.append(IconItem.init(json: configItem))
            }
        } else {
            parsedItems = templateItems
        }
        
        
        
        
        let relativeURL = URL.init(fileURLWithPath: outputPath)
        let folderPath = resultXcasset + "/" + resultIconSet
        let destinationFolderURL = URL.init(fileURLWithPath: folderPath, isDirectory: true, relativeTo: relativeURL)
        do {
            try FileManager.default.createDirectory(at: destinationFolderURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            print("Error create folder")
            exit(EX_USAGE)
        }
        
        for var parsedItem in parsedItems {
            let size = parsedItem.size * CGFloat(parsedItem.scale)

            var additionalInfo = ""

            if let subtype = parsedItem.subtype {
                additionalInfo += "-\(subtype)"
            }

            if let role = parsedItem.role {
                additionalInfo += "-\(role)"
            }

            let imageName = "\(parsedItem.idiom)-\(parsedItem.scale)-\(parsedItem.size)\(additionalInfo).png"
            let imageURL = URL.init(fileURLWithPath: imageName, relativeTo: destinationFolderURL)
            
            image.saveImage(withSize: CGSize(width: size, height: size), at: imageURL)

            parsedItem.filename = imageName
        }
    }
    
    func printHelp() {
        print("usage IconGenerator iconCutter [options]:")
        printKeyDescription(for: baseIconPathKey,
                            description: baseIconDescription)
        printKeyDescription(for: configPathKey,
                            description: configPathDescription)
        printKeyDescription(for: outputPathKey,
                            description: outputPathDescription)
    }
}
