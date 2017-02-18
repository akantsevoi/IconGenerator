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

fileprivate struct IconItem {
    let size: CGFloat
    let idiom: String
    let scale: Int
    let role: String?
    let subtype: String?
    var filename: String?
    
    init(json dict: [String: String]) {
        var newSize = 0.0
        if let sizeString = dict["size"] {
            newSize = Double(String(sizeString.characters.split{$0 == "x"}.first!))!
        }
        size = CGFloat(newSize)
        idiom = dict["idiom"]!
        
        var newScale = 1
        if let strinScale = dict["scale"] {
            newScale = Int(String(strinScale.characters.first!))!
        }
        scale = newScale

        role = dict["role"]
        subtype = dict["subtype"]
    }
}

struct IconCutter: Submodule {
    func process(_ arguments: [String]) {
        self.baseCheckInput(arguments)
        
        let utiliteArguments = self.mapInputArguments(arguments)
        
        let baseIconUrl = self.checkRequiredInput(for: baseIconPathKey,
                                                  in: utiliteArguments)
        
        
        guard let configPath = utiliteArguments[configPathKey] ??
            Bundle.main.path(forResource: defaultTemplateName, ofType: nil) else {
                print("Incorrect template url")
                exit(EX_USAGE)
        }
        
        guard let image = NSImage.init(contentsOfFile: baseIconUrl) else {
            print("Cannot open image")
            exit(EX_USAGE)
        }
        
        let outputPath = utiliteArguments[outputPathKey] ?? defaultOutput
        
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
        
        var parsedItems = [IconItem]()
        
        for configItem in configValues {
            parsedItems.append(IconItem.init(json: configItem))
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
