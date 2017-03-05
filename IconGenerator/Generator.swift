//
//  Generator.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

fileprivate let colorShortKey = "-color"
fileprivate let topShortKey = "-top"
fileprivate let middleShortKey = "-mid"
fileprivate let outputPathShortKey = "-output"
fileprivate let bottomShortKey = "-bot"

fileprivate let defaultColor = "000000"

fileprivate let sizeIcon = 512

fileprivate let topDescription = "String for top area"
fileprivate let middleDescription = "String for middle"
fileprivate let colorDescription = "Background color for generated icon. \n\(tab)\(tab)Hexadecimal format without '#'. Example: -c 000000 \n\(tab)\(tab)Default - \(defaultColor)"
fileprivate let bottomDescription = "String for bottom area"
fileprivate let outputPathDescription = "Output path for Icon."

fileprivate let outputIconName = "BaseIcon.png"

struct Generator: Submodule {
    func process(_ arguments: [String]) {
        
        self.baseCheckInput(arguments)
        
        let utiliteArguments = self.mapInputArguments(arguments)
        
        let topText = self.checkRequiredInput(for: topShortKey,
                                              in: utiliteArguments)
        let midText = self.checkRequiredInput(for: middleShortKey,
                                            in: utiliteArguments)
        
        let botText = utiliteArguments[bottomShortKey]
        
        let output = utiliteArguments[outputPathShortKey] ?? "./"
        let color = "#" + (utiliteArguments[colorShortKey] ?? defaultColor)
        
        guard let inputColor = getColorFromString(hex: color) else {
            print("Incorrect color value: \(color)")
            exit(EX_USAGE)
        }
        
        
        let opposit = contrastColor(to: inputColor)
        
        let image = generateImage(color: inputColor,
                                  size: CGSize.init(width: sizeIcon, height: sizeIcon))
        
        let withText = writeText(onImage: image,
                                 textColor: opposit,
                                 topText: topText,
                                 midText: midText,
                                 bottomText: botText)
        
        var destinationFolderUrl = URL.init(fileURLWithPath: output, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: destinationFolderUrl,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Error create folder")
            exit(EX_USAGE)
        }
        
        destinationFolderUrl.appendPathComponent(outputIconName)
        
        do {
            try withText.savePNGImage(at: destinationFolderUrl)
        } catch let error {
            print("\(error)")
            exit(EX_USAGE)
        }
    }
    
    func printHelp() {
        print("usage IconGenerator generator [options]:")
        printKeyDescription(for: colorShortKey,
                  description: colorDescription)
        printKeyDescription(for: topShortKey,
                  description: topDescription)
        printKeyDescription(for: middleShortKey,
                  description: middleDescription)
        printKeyDescription(for: bottomShortKey,
                  description: bottomDescription)
        printKeyDescription(for: outputPathShortKey,
                  description: outputPathDescription)
    }
}
