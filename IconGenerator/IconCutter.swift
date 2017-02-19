//
//  IconCutter.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

fileprivate let baseIconPathKey = "-base"
fileprivate let configPathKey = "-config"
fileprivate let outputPathKey = "-output"
fileprivate let idiomsKey = "-idioms"

fileprivate let baseIconDescription = "path to original image"
fileprivate let configPathDescription = "path to custom .json template for generate icons"
fileprivate let outputPathDescription = "path for output .xcassets"
fileprivate let idiomsDescription = "Idioms of cutted images. Format: mac-iphone-watch-ipad in random order"

fileprivate let defaultIdioms = "mac-iphone-watch-ipad"
fileprivate let idiomsSeparator = "-"


fileprivate let resultXcasset = "TestIcon.xcassets"
fileprivate let resultIconSet = "AppIcon.appiconset"
fileprivate let defaultTemplateName = "template.json"
fileprivate let defaultOutput = "./"

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
        
        let idiomString = utiliteArguments[idiomsKey] ?? defaultIdioms
        
        let idioms = idiomString.components(separatedBy: idiomsSeparator)
        
        
        let outputPath = utiliteArguments[outputPathKey] ?? defaultOutput
        
        
        
        let folderPath = outputPath + "/" + resultXcasset + "/" + resultIconSet
        let destinationFolderURL = URL.init(fileURLWithPath: folderPath, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: destinationFolderURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            print("Error create folder")
            exit(EX_USAGE)
        }
        
        var outputJSONObject = [String: AnyObject]()
        var itemObjects = [AnyObject]()
        
        for var parsedItem in parsedItems {
            if idioms.contains(parsedItem.idiom) {
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
                
                itemObjects.append(parsedItem.JSONRepresentation)
            }
        }
        
        outputJSONObject["images"] = itemObjects as AnyObject?
        let info: [String: String] = [ "version":"1", "author" : "xcode"]
        outputJSONObject["info"] = info as AnyObject?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: outputJSONObject,
                                                  options: .prettyPrinted)
            if let jsonURL = URL.init(string: "Contents.json", relativeTo: destinationFolderURL) {
                do {
                    try data.write(to: jsonURL)
                } catch {
                    print("Error write Contents.json file")
                    exit(EX_USAGE)
                }
            } else {
                print("Error create Contents.json url")
                exit(EX_USAGE)
            }
        } catch {
            print("Error configure Contents.json file")
            exit(EX_USAGE)
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
        printKeyDescription(for: idiomsKey,
                            description: idiomsDescription)
    }
}
